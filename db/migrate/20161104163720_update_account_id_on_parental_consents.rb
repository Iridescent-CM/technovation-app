class UpdateAccountIdOnParentalConsents < ActiveRecord::Migration
  def change
    remove_foreign_key :parental_consents, :accounts
    rename_column :parental_consents, :account_id, :student_profile_id
    add_foreign_key :parental_consents, :student_profiles
  end
end
