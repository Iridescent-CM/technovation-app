desc "Update existing student profile parental/guardian consent email with en locale"
task update_all_existing_student_profile_parental_consent_email_locales: :environment do
  StudentProfile.where(parent_guardian_consent_locale: nil).update_all(parent_guardian_consent_locale: "en")
end
