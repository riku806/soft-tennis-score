class PointsController < ApplicationController
  before_action :set_point, only: %i[show edit update destroy]

  # GET /points
  def index
    @points = Point.all
  end

  # GET /points/1
  def show
  end

  # GET /points/new
  def new
    @point = Point.new
  end

  # GET /points/1/edit
  def edit
  end

  # POST /points
   def create
  # ★ 試合全体のポイント番号を計算
  next_point_number = @game.points.maximum(:point_number).to_i + 1

    @game = Game.find(params[:game_id])

    @game.current_game_number ||= 1

    Point.create!(
      game: @game,
      winner: params[:winner],
      game_number: @game.current_game_number,
      player: params[:player],
      play_code: params[:code]
      point_number: next_point_number
    )

    @game.p_score ||= 0
    @game.q_score ||= 0

    if params[:winner] == "P"
      @game.p_score += 1
    else
      @game.q_score += 1
    end
    #これでゲーム終了判定
# 現在のゲーム数
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

  # ファイナルゲーム
  game_end =
    (@game.p_score >= 7 || @game.q_score >= 7) &&
    (@game.p_score - @game.q_score).abs >= 2

else

  # 通常ゲーム
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

  # 試合全体のゲーム数を数える
# 終了したゲーム数
p_games = @game.points.where(winner: "RESULT")
                      .where("p_gamescore > q_gamescore")
                      .count

q_games = @game.points.where(winner: "RESULT")
                      .where("q_gamescore > p_gamescore")
                      .count

  # 4ゲーム先取で試合終了
  if p_games >= 4 || q_games >= 4

    @game.update(
      p_result: p_games,
      q_result: q_games
    )

  end

  # 次のゲームへ
  @game.current_game_number += 1

  @game.p_score = 0
  @game.q_score = 0

  end

    @game.save!

    if p_games >= 4 || q_games >= 4
      redirect_to match_path(@game.match)
    else
      redirect_to game_path(@game)
    end
    
    end
  # PATCH/PUT /points/1
  def update
    respond_to do |format|
      if @point.update(point_params)
        format.html { redirect_to @point, notice: "Point was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @point }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @point.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /points/1
  def destroy
    @point.destroy!

    respond_to do |format|
      format.html { redirect_to points_path, notice: "Point was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
    end
  end

  private

  def set_point
    @point = Point.find(params[:id])
  end

  def point_params
    params.require(:point).permit(:game_id, :winner, :kind)
  end
end