class AddEditableRegions < ActiveRecord::Migration
  def up
    create_table :regions do |t|
      t.string  :region_name
      t.integer :division
      t.integer :num_finalists, :null => false, :default => 1
      t.timestamps
    end

    rename_column :events, :region, :region_id
    rename_column :teams, :region, :region_id
    rename_column :users, :conflict_region, :conflict_region_id
    rename_column :users, :judging_region, :judging_region_id

    add_index :events, :region_id
    add_index :teams, :region_id
    add_index :users, :conflict_region_id
    add_index :users, :judging_region_id
  end

  def down
    remove_index :users, :judging_region_id
    remove_index :users, :conflict_region_id
    remove_index :teams, :region_id
    remove_index :events, :region_id

    rename_column :users, :judging_region_id, :judging_region
    rename_column :users, :conflict_region_id, :conflict_region
    rename_column :teams, :region_id, :region
    rename_column :events, :region_id, :region

    drop_table :regions
  end
end
