# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_07_16_025944) do
  create_table "games", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "number"
    t.integer "p_score"
    t.integer "q_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_game_number"
    t.integer "final_p_score"
    t.integer "final_q_score"
    t.boolean "in_final"
    t.string "result"
    t.string "p_school"
    t.string "p_front"
    t.string "p_back"
    t.string "q_school"
    t.string "q_front"
    t.string "q_back"
    t.integer "p_result"
    t.integer "q_result"
    t.string "start_type"
    t.index ["match_id"], name: "index_games_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "title"
    t.string "court"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "final_mode"
    t.string "p_pair"
    t.string "q_pair"
    t.string "p_school"
    t.string "q_school"
    t.string "p_front"
    t.string "p_back"
    t.string "q_front"
    t.string "q_back"
    t.date "date"
  end

  create_table "points", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "winner"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_number"
    t.integer "p_gamescore"
    t.integer "q_gamescore"
    t.string "player"
    t.string "play_code"
    t.string "serve_number"
    t.integer "point_number"
    t.string "server"
    t.index ["game_id"], name: "index_points_on_game_id"
  end

  add_foreign_key "games", "matches"
  add_foreign_key "points", "games"
end
