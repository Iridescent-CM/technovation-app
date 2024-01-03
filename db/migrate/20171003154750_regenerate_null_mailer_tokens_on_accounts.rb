class RegenerateNullMailerTokensOnAccounts < ActiveRecord::Migration[5.1]
  def change
    Account.where(mailer_token: [nil, ""]).find_each do |a|
      token = SecureRandom.base58(24)
      a.update_columns(mailer_token: token)
    rescue ActiveRecord::RecordNotUnique
      token = SecureRandom.base58(24)
      a.update_columns(mailer_token: token)
    end
  end
end
