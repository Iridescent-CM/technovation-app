class AddVisibleOnMapToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :visible_on_map, :boolean, default: true
  end
end
