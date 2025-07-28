class AddForceChapterableSelectionToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :force_chapterable_selection, :boolean, default: false
  end
end
