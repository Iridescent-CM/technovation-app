class CreateSeasonRegistrations < ActiveRecord::Migration[4.2]
  def change
    create_table :season_registrations do |t|
      t.references :season, index: true, foreign_key: true, null: false
      t.references :registerable, polymorphic: true, null: false

      t.timestamps null: false

      t.index :registerable_type, name: :season_registerable_types
      t.index :registerable_id, name: :season_registerable_ids
    end
  end
end
