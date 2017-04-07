class AddDownloadTokenToFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :download_token, :string
  end
end
