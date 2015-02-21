class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
     add_column :teams, :category_id, :integer
     add_index :category_id, :key, unique: true
  end
end
