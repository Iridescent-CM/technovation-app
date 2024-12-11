class RenameNoChapterSelectedToNoChapterableSelected < ActiveRecord::Migration[6.1]
  def change
    rename_column :accounts, :no_chapter_selected, :no_chapterable_selected
  end
end
