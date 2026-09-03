class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.string :title
      t.string :court

      t.timestamps
    end
  end
end
