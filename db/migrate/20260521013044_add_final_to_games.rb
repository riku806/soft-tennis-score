class AddFinalToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :final_p_score, :integer
    add_column :games, :final_q_score, :integer
    add_column :games, :in_final, :boolean
  end
end
