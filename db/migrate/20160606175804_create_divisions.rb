class CreateDivisions < ActiveRecord::Migration[4.2]
  def change
    create_table :divisions do |t|
      t.integer :name, null: false

      t.timestamps null: false
    end
  end
end
