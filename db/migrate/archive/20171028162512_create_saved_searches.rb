class CreateSavedSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_searches do |t|
      t.references :searcher, polymorphic: true, null: false
      t.string :name, null: false
      t.string :search_string, null: false
      t.string :param_root, null: false

      t.timestamps
    end
  end
end
