class MoveResultsFromMatchesToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :p_result, :integer
    add_column :games, :q_result, :integer

    remove_column :matches, :p_result, :integer
    remove_column :matches, :q_result, :integer
  end
end
