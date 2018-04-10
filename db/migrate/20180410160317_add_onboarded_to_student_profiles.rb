class AddOnboardedToStudentProfiles < ActiveRecord::Migration[5.1]
  def up
    add_column :student_profiles, :onboarded, :boolean, default: false

    StudentProfile.current.find_each do |s|
      if s.signed_parental_consent.blank? or
          s.account.email_confirmed_at.blank? or
            s.account.latitude.blank?
        s.update_column(:onboarded, false)
      else
        s.update_column(:onboarded, true)
      end
    end
  end

  def down
    remove_column :student_profiles, :onboarded
  end
end
