class ResetVulnerablePasswords
  def self.perform!
    accounts = Account.not_admin.where(
      "created_at::date BETWEEN '2018-10-01' AND '2018-11-13'"
    )

    accounts.find_each do |account|
      if account.authenticate(account.email)
        account.skip_existing_password = true
        account.password = SecureRandom.base58(48)
        account.regenerate_auth_token
      end
    end
  end
end