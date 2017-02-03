class AddDownloadTokenToFiles < ActiveRecord::Migration
  def change
    add_column :exports, :download_token, :string
  end
end
