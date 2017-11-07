class AddDownloadedToExports < ActiveRecord::Migration[5.1]
  def change
    add_column :exports, :downloaded, :boolean, null: false, default: false
  end
end
