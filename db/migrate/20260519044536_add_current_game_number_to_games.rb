class AddCurrentGameNumberToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :current_game_number, :integer
  end
end
