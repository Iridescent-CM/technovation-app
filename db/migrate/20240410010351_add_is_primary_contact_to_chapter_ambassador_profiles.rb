class AddIsPrimaryContactToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :chapter_ambassador_profiles, :is_primary_contact, :boolean, null: true
  end
end
