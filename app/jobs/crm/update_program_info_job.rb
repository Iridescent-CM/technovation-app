class CRM::UpdateProgramInfoJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Salesforce::ApiClient
      .new(
        account: account,
        profile_type: profile_type
      )
      .update_program_info
  end
end
