class AddPointNumberToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :point_number, :integer
  end
end
