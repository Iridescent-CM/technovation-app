class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :season, index: true, foreign_key: true, null: false
      t.references :registerable, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
