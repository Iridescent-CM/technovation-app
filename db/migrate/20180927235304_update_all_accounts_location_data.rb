class UpdateAllAccountsLocationData < ActiveRecord::Migration[5.1]
  def up
    Account.find_each(&:save!)
    Team.find_each(&:save!)
    SignupAttempt.find_each(&:save!)
  end
end
