class SubscribeProfileToEmailList < ActiveJob::Base
  queue_as :default

  def perform(account_id, list_env_key)
    return if Rails.env.development? or Rails.env.test?

    account = Account.find(account_id)

    SubscribeEmailListJob.perform_now(
      account.email,
      account.full_name,
      list_env_key,
      [{ Key: 'City', Value: account.city },
        { Key: 'State/Province', Value: account.state_province },
        { Key: 'Country', Value: FriendlyCountry.(account, prefix: false) }]
    )
  end
end
