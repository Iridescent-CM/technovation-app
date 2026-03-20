class AddParentGuardianConsentLocaleToStudentProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :student_profiles, :parent_guardian_consent_locale, :string, default: "en"
  end
end
