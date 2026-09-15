class AddStartTypeToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :start_type, :string
  end
end
