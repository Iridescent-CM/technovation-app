class AddConflictRegionToUser < ActiveRecord::Migration
  def change
    add_column :users, :conflict_region, :integer
  end
end
