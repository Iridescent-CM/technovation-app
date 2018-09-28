class UpdateAllAccountsLocationData < ActiveRecord::Migration[5.1]
  def up
    Account.find_each(&:fix_state_country_formatting_with_save)
    Team.find_each(&:fix_state_country_formatting_with_save)
    SignupAttempt.find_each(&:fix_state_country_formatting_with_save)
  end
end
