class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.references :game, null: false, foreign_key: true
      t.string :winner
      t.string :kind

      t.timestamps
    end
  end
end
