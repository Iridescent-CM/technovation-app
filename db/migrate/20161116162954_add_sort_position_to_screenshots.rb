class AddSortPositionToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :sort_position, :integer, null: false, default: 0
    add_index :screenshots, :sort_position
  end
end
