class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :value

      t.timestamps null: false
    end
  end
end
