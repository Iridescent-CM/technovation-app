class RenameChapterAccountAssignmentsToChapterableAccountAssignments < ActiveRecord::Migration[6.1]
  def change
    rename_table :chapter_account_assignments, :chapterable_account_assignments
  end
end
