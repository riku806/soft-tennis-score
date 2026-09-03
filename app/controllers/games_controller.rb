class GamesController < ApplicationController
  before_action :set_game, only: %i[
    show edit update destroy
    p_point q_point
    play
  ]

  # GET /games
  def index
    @games = Game.all
  end

  # GET /games/1
  def show
  end

  def start
    @game = Game.find(params[:id])
  end

  def set_start
    @game = Game.find(params[:id])

    @game.update!(
      start_type: params[:start_type]
    )

    redirect_to game_path(@game)
  end

  def play
  puts "player=#{params[:player]}"
  puts "P_FRONT=#{@game.p_front}"
  puts "P_BACK=#{@game.p_back}"
  puts "Q_FRONT=#{@game.q_front}"
  puts "Q_BACK=#{@game.q_back}"
  @game = Game.find(params[:id])

  side =
    if [@game.p_front, @game.p_back].include?(params[:player])
      "P"
    else
      "Q"
    end

  point_for_player =
    params[:code] == "SA" ||
    params[:code].end_with?("P") ||
    params[:code].end_with?("NinP")

  winner =
    if point_for_player
      side
    else
      side == "P" ? "Q" : "P"
    end

  @game.current_game_number ||= 1

  current_server = current_server(@game)

  Point.create!(
  game: @game,
  winner: winner,
  game_number: @game.current_game_number,
  player: params[:player],
  play_code: params[:code],
  serve_number: params[:serve],
  server: current_server
)

  @game.p_score ||= 0
  @game.q_score ||= 0

  if winner == "P"
    @game.p_score += 1
  else
    @game.q_score += 1
  end

    # 終了したゲーム数
  p_games = @game.points.where(winner: "RESULT")
                        .where("p_gamescore > q_gamescore")
                        .count

  q_games = @game.points.where(winner: "RESULT")
                        .where("q_gamescore > p_gamescore")
                        .count

  # ファイナルゲーム判定
  final_game = (p_games == 3 && q_games == 3)

  # ゲーム終了判定
  if final_game
    game_end =
      (@game.p_score >= 7 || @game.q_score >= 7) &&
      (@game.p_score - @game.q_score).abs >= 2
  else
    game_end =
      (@game.p_score >= 4 || @game.q_score >= 4) &&
      (@game.p_score - @game.q_score).abs >= 2
  end

  if game_end

    Point.create!(
      game: @game,
      winner: "RESULT",
      game_number: @game.current_game_number,
      p_gamescore: @game.p_score,
      q_gamescore: @game.q_score
    )

    # ゲーム数を再計算
    p_games = @game.points.where(winner: "RESULT")
                          .where("p_gamescore > q_gamescore")
                          .count

    q_games = @game.points.where(winner: "RESULT")
                          .where("q_gamescore > p_gamescore")
                          .count

    # 試合終了判定
    if p_games >= 4 || q_games >= 4
      @game.p_result = p_games
      @game.q_result = q_games
    end

    # 次のゲームへ
    @game.current_game_number += 1
    @game.p_score = 0
    @game.q_score = 0
  end

  @game.save!

  if @game.p_result.present? || @game.q_result.present?
    redirect_to match_path(@game.match)
  else
    redirect_to game_path(@game)
  end

  end

def undo
  @game = Game.find(params[:id])

  last_point = @game.points
                    .where.not(winner: "RESULT")
                    .order(:created_at)
                    .last

  if last_point
    if last_point.winner == "P"
      @game.p_score -= 1
    else
      @game.q_score -= 1
    end

    last_point.destroy
    @game.save!
  end

  redirect_to game_path(@game)
end

  # GET /games/new
  def new
    @game = Game.new
    @game.match_id = params[:match_id]
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    @game.p_score = 0
    @game.q_score = 0
    @game.current_game_number = 1

    @game.final_p_score = 0
    @game.final_q_score = 0
    @game.in_final = false
    @game.result = nil

  if @game.save
    redirect_to start_game_path(@game)
  else
    render :new, status: :unprocessable_content
  end

  end

  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
      redirect_to @game,
      notice: "Game was successfully updated.",
      status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /games/1
  def destroy
    match = @game.match

    @game.destroy!

    redirect_to match_path(match),
      notice: "試合を削除しました",
      status: :see_other
  end

def current_server(game)
  # 何ゲーム目か（0始まり）
  game_index = game.current_game_number - 1

  # このゲームのサーブ側
  if game.start_type == "serve"
    serve_side = game_index.even? ? "P" : "Q"
  else
    serve_side = game_index.even? ? "Q" : "P"
  end

  # このゲームで何ポイント終了したか
  point_count = game.points
                    .where(game_number: game.current_game_number)
                    .where.not(winner: "RESULT")
                    .count

  # 2ポイントごとに後衛→前衛
  server_index = (point_count / 2) % 2

  server_position =
    if server_index == 0
      "back"
    else
      "front"
    end

  if serve_side == "P"
    server_position == "back" ? game.p_back : game.p_front
  else
    server_position == "back" ? game.q_back : game.q_front
  end
end

  # Pポイント
    def p_point
    if @game.in_final
      @game.final_p_score += 1
    else
      @game.p_score += 1
    end

    # 3-3でファイナル開始
    if @game.p_score == 3 && @game.q_score == 3
      @game.in_final = true
    end

    # ファイナル勝利判定
    if (@game.final_p_score >= 7 || @game.final_q_score >= 7) &&
       (@game.final_p_score - @game.final_q_score).abs >= 2

      @game.result = "P勝利"
    end

    @game.save
    redirect_to @game
  end

  # Qポイント
  def q_point
    if @game.in_final
      @game.final_q_score += 1
    else
      @game.q_score += 1
    end

    # 3-3でファイナル開始
    if @game.p_score == 3 && @game.q_score == 3
      @game.in_final = true
    end

    # ファイナル勝利判定
    if (@game.final_p_score >= 7 || @game.final_q_score >= 7) &&
       (@game.final_p_score - @game.final_q_score).abs >= 2

      @game.result = "Q勝利"
    end

    @game.save
    redirect_to @game
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(
      :match_id,
      :number,
      :p_score,
      :q_score,

      :p_school,
      :p_front,
      :p_back,

      :q_school,
      :q_front,
      :q_back,

      :start_type
    )
  end
end

