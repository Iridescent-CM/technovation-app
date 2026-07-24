# frozen_string_literal: true

module Admin
  class DeactivateInactiveAccounts
    def self.call
      new.call
    end

    def call
      deactivated_count = 0

      Account.inactive_admins_for_deactivation.find_each do |account|
        deactivate!(account)
        deactivated_count += 1
      end

      deactivated_count
    end

    private

    def deactivate!(account)
      cutoff = Account::ADMIN_INACTIVITY_DEACTIVATION_AFTER.ago

      account.update!(deactivated_at: Time.current)
      account.regenerate_auth_token

      SecurityEventLogger.log(
        event_type: "admin.deactivated",
        account: account,
        metadata: {
          last_logged_in_at: account.last_logged_in_at,
          inactivity_cutoff: cutoff,
          reason: "inactive_admin"
        }
      )
    end
  end
end
