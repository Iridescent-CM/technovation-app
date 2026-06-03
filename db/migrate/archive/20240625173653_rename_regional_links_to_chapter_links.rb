class RenameRegionalLinksToChapterLinks < ActiveRecord::Migration[6.1]
  def change
    rename_table :regional_links, :chapter_links
  end
end
