class AddPhoneNumberToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :chapter_ambassador_profiles, :phone_number, :string
  end
end
