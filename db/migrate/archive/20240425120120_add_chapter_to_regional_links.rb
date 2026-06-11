class AddChapterToRegionalLinks < ActiveRecord::Migration[6.1]
  def change
    add_reference :regional_links, :chapter, foreign_key: true
  end
end
