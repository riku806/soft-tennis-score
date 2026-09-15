class AddPlayerAndPlayCodeToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :player, :string
    add_column :points, :play_code, :string
  end
end
