class ResetVulnerablePasswords
  def self.perform!
    unless Rails.env.test?
      Rails.logger.extend(
        ActiveSupport::Logger.broadcast(
          Logger.new(STDOUT)
        )
      )
    end

    Rails.logger.info("Starting reset of vulnerable passwords...")

    accounts = Account.not_admin.where(
      "created_at::date BETWEEN '2018-10-01' AND '2018-11-13'"
    )

    Rails.logger.info("Found #{accounts.count} accounts signed up before the bug was fixed...")

    CSV.open("./tmp/password-reset-affected-users.csv", "wb") do |rows|
      rows << ["Email", "First name", "Last name", "Profile type"]

      accounts.find_each.with_index do |account, i|
        if account.authenticate(account.email)
          Rails.logger.info("#{i + 1}. RESETTING #{account.email}")

          account.skip_existing_password = true
          account.password = SecureRandom.base58(48)
          account.regenerate_auth_token

          rows << [
            account.email,
            account.first_name,
            account.last_name,
            account.scope_name
          ]
        else
          Rails.logger.info("#{i + 1}. SKIPPING #{account.email}")
        end
      end
    end

    file = File.open("./tmp/password-reset-affected-users.csv")

    if CSV.parse(file.read).size > 1
      Rails.logger.info("Creating the CSV export...")

      export = Export.create!(
        file: file,
        owner: Account.full_admin.sample
      )

      Rails.logger.info("Emailing the file to all the admins...")

      Account.full_admin.each do |admin|
        FilesMailer.report_affected_users(admin, export).deliver_now
      end
    else
      Rails.logger.info("No results are in the CSV to send an email")
    end

    Rails.logger.info("Done!")
  end
end
