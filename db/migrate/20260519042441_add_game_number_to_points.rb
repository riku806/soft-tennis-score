class AddGameNumberToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :game_number, :integer
  end
end
