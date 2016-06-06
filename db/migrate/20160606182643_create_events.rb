class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.datetime :starts_at, null: false
      t.references :organizer, index: true, null: false
      t.references :region, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
