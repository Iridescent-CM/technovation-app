task invite_ras: :environment do
  ActiveRecord::Base.transaction do
    CSV.foreach(
      "./lib/2018_ra_import.csv",
      headers: true,
      header_converters: :symbol
    ) do |row|
      next if (
        row[:date_of_birth].blank? ||
          row[:bio].blank? ||
            RegionalAmbassadorProfile.joins(:account)
              .find_by("accounts.email = ?", row[:email])
      )

      attempt = SignupAttempt.find_by(email: row[:email]) ||
        SignupAttempt.create!(
          email: row[:email],
          password: SecureRandom.hex(17),
          status: SignupAttempt.statuses[:temporary_password]
        )

      attempt.temporary_password!

      account = Account.find_by(email: row[:email]) || attempt.build_account(
        email: row[:email],
      )

      account.update(
        first_name: row[:first_name],
        last_name: row[:last_name],
        city: row[:city],
        state_province: row[:state_province],
        country: row[:country],
        date_of_birth: Date.strptime(row[:date_of_birth], "%m/%d/%Y"),
        password: SecureRandom.hex(17),
        email_confirmed_at: Time.current,
        skip_existing_password: true,
      )

      account.create_regional_ambassador_profile!(
        organization_company_name: row[:organization_company_name],
        job_title: row[:job_title],
        bio: row[:bio],
        ambassador_since_year: "I'm new!",
        status: :approved,
      )

      attempt.regenerate_admin_permission_token

      RegistrationMailer.admin_permission(attempt.id).deliver_now
    end
  end
end
