class AddServeNumberToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :serve_number, :string
  end
end
