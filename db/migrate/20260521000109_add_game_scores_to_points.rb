class AddGameScoresToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :p_gamescore, :integer
    add_column :points, :q_gamescore, :integer
  end
end
