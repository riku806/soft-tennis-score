class AddFinalModeToMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :final_mode, :boolean
  end
end
