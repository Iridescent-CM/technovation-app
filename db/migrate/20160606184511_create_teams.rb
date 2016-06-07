class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :division, index: true, foreign_key: true, null: false
      t.references :region, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
