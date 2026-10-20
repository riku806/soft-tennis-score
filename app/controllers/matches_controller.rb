class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy players ]

  # GET /matches or /matches.json
  def index
    @matches = Match.left_joins(:games).distinct

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"

      @matches = @matches.where(
        "matches.title LIKE :keyword OR
        matches.date LIKE :keyword OR
        games.p_school LIKE :keyword OR
        games.q_school LIKE :keyword OR
        games.p_front LIKE :keyword OR
        games.p_back LIKE :keyword OR
        games.q_front LIKE :keyword OR
        games.q_back LIKE :keyword" ,
      keyword: keyword
      ).distinct
    end
  end
  # GET /matches/1 or /matches/1.json

def show
  @match = Match.find(params[:id])
  @games = @match.games.order(:created_at)

  if params[:q].present?
    keyword = "%#{params[:q]}%"

    @games = @games.where(
      "p_school LIKE :keyword OR
       q_school LIKE :keyword OR
       p_front LIKE :keyword OR
       p_back LIKE :keyword OR
       q_front LIKE :keyword OR
       q_back LIKE :keyword",
      keyword: keyword
    )
  end

  
# 勝敗数
@wins = 0
@losses = 0

keyword = params[:q].to_s.strip

@games.each do |game|
  p_score = game.p_result.to_i
  q_score = game.q_result.to_i

  # 未終了の試合は集計しない
  next if p_score == 0 && q_score == 0

  # 学校名が同じか判定
  same_school = game.p_school.present? &&
                game.p_school == game.q_school

  # 検索対象に該当するか判定
  p_names = [game.p_school, game.p_front, game.p_back].compact
  q_names = [game.q_school, game.q_front, game.q_back].compact

  p_found = keyword.blank? ||
            p_names.any? { |name| name.include?(keyword) }

  q_found = keyword.blank? ||
            q_names.any? { |name| name.include?(keyword) }

  next unless p_found || q_found

if same_school
  # 同じ学校同士：両側をそれぞれ集計
  if p_score > q_score
    @wins += 1
    @losses += 1
  elsif q_score > p_score
    @losses += 1
    @wins += 1
  end
  else
    # 他校同士：P側を基準にする
    @wins += 1 if p_found && p_score > q_score
    @losses += 1 if p_found && p_score < q_score

    # Q側の学校だけが検索対象の場合も、P側基準の結果を反転
    if !p_found && q_found
      @wins += 1 if q_score > p_score
      @losses += 1 if q_score < p_score
    end
  end
end



  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches or /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @match.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)

      

        format.html { redirect_to match_path (@match)}

      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json  end
  
  def destroy
    @match.destroy!

    respond_to do |format|
      format.html { redirect_to matches_path, notice: "Match was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def players
  @match = Match.find(params[:id])

  @game = @match.games.build(
    number: @match.games.count + 1
  )
  end
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def match_params
    params.expect(match: [

      :title,
      :court,
      :date,
      :p_front,
      :p_back,
      :p_school,
      :q_front,
      :q_back,
      :q_school

    ])
  end
end
