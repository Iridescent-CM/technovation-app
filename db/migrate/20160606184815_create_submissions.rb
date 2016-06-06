class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :team, index: true, foreign_key: true
      t.text :description
      t.string :code
      t.string :pitch
      t.string :demo

      t.timestamps null: false
    end
  end
end
