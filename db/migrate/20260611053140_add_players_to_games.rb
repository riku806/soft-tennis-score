class AddPlayersToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :p_school, :string
    add_column :games, :p_front, :string
    add_column :games, :p_back, :string
    add_column :games, :q_school, :string
    add_column :games, :q_front, :string
    add_column :games, :q_back, :string
  end
end
