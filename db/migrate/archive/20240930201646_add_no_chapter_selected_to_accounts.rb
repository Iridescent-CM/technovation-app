class AddNoChapterSelectedToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :no_chapter_selected, :boolean
  end
end
