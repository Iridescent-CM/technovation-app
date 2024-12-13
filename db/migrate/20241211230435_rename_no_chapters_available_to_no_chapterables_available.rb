class RenameNoChaptersAvailableToNoChapterablesAvailable < ActiveRecord::Migration[6.1]
  def change
    rename_column :accounts, :no_chapters_available, :no_chapterables_available
  end
end
