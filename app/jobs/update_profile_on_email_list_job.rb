class UpdateProfileOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, email_was, list_env_key)
    return if Rails.env.development? or Rails.env.test?

    account = Account.find(account_id)

    UpdateProfileOnEmailListJob.perform_now(
      email_was,
      account.email,
      account.full_name,
      list_env_key,
      [{ Key: 'City', Value: account.city },
        { Key: 'State/Province', Value: account.state_province },
        { Key: 'Country', Value: account.get_country }]
    )
  end
end
