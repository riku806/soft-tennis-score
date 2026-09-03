class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :match, null: false, foreign_key: true
      t.integer :number
      t.integer :p_score
      t.integer :q_score

      t.timestamps
    end
  end
end
