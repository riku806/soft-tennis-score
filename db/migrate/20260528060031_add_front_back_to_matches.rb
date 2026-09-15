class AddFrontBackToMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :p_front, :string
    add_column :matches, :p_back, :string

    add_column :matches, :q_front, :string
    add_column :matches, :q_back, :string
  end
end
