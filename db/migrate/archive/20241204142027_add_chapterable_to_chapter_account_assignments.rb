class AddChapterableToChapterAccountAssignments < ActiveRecord::Migration[6.1]
  def change
    rename_column :chapter_account_assignments, :chapter_id, :chapterable_id
    add_column :chapter_account_assignments, :chapterable_type, :string
    add_index :chapter_account_assignments, [:chapterable_type, :chapterable_id], name: "index_chapter_account_assignments_on_chapter"
  end
end
