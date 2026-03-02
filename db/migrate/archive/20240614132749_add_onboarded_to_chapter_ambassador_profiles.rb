class AddOnboardedToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :chapter_ambassador_profiles, :onboarded, :boolean, default: false
  end
end
