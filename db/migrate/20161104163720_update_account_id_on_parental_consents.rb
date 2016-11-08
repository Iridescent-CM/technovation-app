class UpdateAccountIdOnParentalConsents < ActiveRecord::Migration
  def up
    remove_foreign_key :parental_consents, :accounts

    ParentalConsent.find_each do |pc|
      puts ""
      puts "--------------------------------------------------------------------------"
      profile = StudentProfile.find_by(account_id: pc.account_id)
      pc.update_column(:account_id, profile.id)
      puts "Assigned #{profile.email} student profile to Parental Consent #{pc.id}"
      puts "--------------------------------------------------------------------------"
      puts ""
    end

    rename_column :parental_consents, :account_id, :student_profile_id
    add_foreign_key :parental_consents, :student_profiles
  end

  def down
    remove_foreign_key :parental_consents, :student_profiles

    ParentalConsent.find_each do |pc|
      puts ""
      puts "--------------------------------------------------------------------------"
      account = StudentProfile.find(pc.student_profile_id).account
      pc.update_column(:student_profile_id, account.id)
      puts "Assigned #{account.email} account to Parental Consent #{pc.id}"
      puts "--------------------------------------------------------------------------"
      puts ""
    end

    rename_column :parental_consents, :student_profile_id, :account_id
    add_foreign_key :parental_consents, :accounts
  end
end
