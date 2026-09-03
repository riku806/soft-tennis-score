class AddResultToMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :p_result, :integer
    add_column :matches, :q_result, :integer
  end
end
