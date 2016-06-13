class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :name, null: false

      t.timestamps null: false
    end
    add_index :roles, :name
  end
end
