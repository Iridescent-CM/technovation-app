class RenameTableRegionalAmbassadorProfilesToChapterAmbassadorProfiles < ActiveRecord::Migration[5.1]
  def change
    rename_table :regional_ambassador_profiles, :chapter_ambassador_profiles
  end
end
