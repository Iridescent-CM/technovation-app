class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.datetime :starts_at, null: false
      t.references :organizer, index: true, null: false

      t.timestamps null: false
    end
  end
end
