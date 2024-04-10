class AddPrimaryChatperAmbassadorToChapters < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapters, :primary_chapter_ambassador_profile, null: true, foreign_key: {to_table: :chapter_ambassador_profiles}
  end
end
