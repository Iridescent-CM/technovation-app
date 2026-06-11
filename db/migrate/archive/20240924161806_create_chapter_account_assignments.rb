class CreateChapterAccountAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :chapter_account_assignments do |t|
      t.belongs_to :chapter
      t.belongs_to :account
      t.references :profile, polymorphic: true, index: true

      t.integer :season, limit: 2
      t.boolean :primary

      t.index [:chapter_id, :account_id], name: "index_table_chapter_account_assignments_on_chapter_account_ids"
      t.index [:account_id, :chapter_id], name: "index_table_chapter_account_assignments_on_account_chapter_ids"

      t.timestamps
    end
  end
end
