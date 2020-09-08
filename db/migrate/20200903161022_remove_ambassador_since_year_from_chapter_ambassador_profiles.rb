class RemoveAmbassadorSinceYearFromChapterAmbassadorProfiles < ActiveRecord::Migration[5.2]
  def change
     remove_column :chapter_ambassador_profiles, :ambassador_since_year, :string
  end
end
