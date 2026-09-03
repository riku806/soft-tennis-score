class AddServerToPoints < ActiveRecord::Migration[8.0]
  def change
    add_column :points, :server, :string
  end
end
