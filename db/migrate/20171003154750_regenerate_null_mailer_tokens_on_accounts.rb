class RegenerateNullMailerTokensOnAccounts < ActiveRecord::Migration[5.1]
  def change
    Account.where(mailer_token: [nil, ""]).find_each do |a|
      a.regenerate_mailer_token
    end
  end
end
