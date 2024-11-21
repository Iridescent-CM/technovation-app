class CreateClubs < ActiveRecord::Migration[6.1]
  def change
    create_table :clubs do |t|
      t.string :name
      t.text :summary
      t.string :headquarters_location
      t.boolean :visible_on_map, default: true
      t.string :city
      t.string :state_province
      t.string :country
      t.float :latitude
      t.float :longitude

      t.references :primary_account, null: true, foreign_key: {to_table: :accounts}

      t.timestamps
    end
  end
end
