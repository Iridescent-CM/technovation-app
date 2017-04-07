class UpdateAccountIdOnParentalConsents < ActiveRecord::Migration[4.2]
  def up
    logger = Logger.new("log/accounts-profiles-migrations-up.log")

    remove_foreign_key :parental_consents, :accounts

    ParentalConsent.find_each do |pc|
      logger.info ""
      logger.info "--------------------------------------------------------------------------"

      profile = StudentProfile.find_by(account_id: pc.account_id)
      pc.update_column(:account_id, profile.id)

      logger.info "Assigned #{profile.email} student profile to Parental Consent #{pc.id}"
      logger.info "--------------------------------------------------------------------------"
      logger.info ""
    end

    rename_column :parental_consents, :account_id, :student_profile_id
    add_foreign_key :parental_consents, :student_profiles
  end

  def down
    logger = Logger.new("log/accounts-profiles-migrations-down.log")

    remove_foreign_key :parental_consents, :student_profiles

    ParentalConsent.find_each do |pc|
      logger.info ""
      logger.info "--------------------------------------------------------------------------"

      account = StudentProfile.find(pc.student_profile_id).account
      pc.update_column(:student_profile_id, account.id)

      logger.info "Assigned #{account.email} account to Parental Consent #{pc.id}"
      logger.info "--------------------------------------------------------------------------"
      logger.info ""
    end

    rename_column :parental_consents, :student_profile_id, :account_id
    add_foreign_key :parental_consents, :accounts
  end
end
