class RemovePhoneNumberFromChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :chapter_ambassador_profiles, :phone_number
  end
end
