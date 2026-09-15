json.extract! game, :id, :match_id, :number, :p_score, :q_score, :created_at, :updated_at
json.url game_url(game, format: :json)
