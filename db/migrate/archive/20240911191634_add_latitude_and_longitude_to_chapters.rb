class AddLatitudeAndLongitudeToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :latitude, :float
    add_column :chapters, :longitude, :float
  end
end
