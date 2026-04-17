class AddOpenToPublicToChapters < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :open_to_public, :boolean, default: true, null: false
  end
end
