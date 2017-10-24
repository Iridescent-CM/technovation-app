module InviteRA
  def self.call(attrs)
    if attempt = SignupAttempt.find_by(email: attrs[:email])
      attempt.destroy
    end

    attempt = SignupAttempt.create!(
      email: attrs[:email],
      password: SecureRandom.hex(17),
      status: SignupAttempt.statuses[:temporary_password],
    )

    if account = Account.find_by(email: attrs[:email])
      background_check = account.background_check
      account.destroy
    end

    account = attempt.create_account!(
      email: attrs[:email],
      first_name: attrs[:first_name],
      last_name: attrs[:last_name],
      city: attrs[:city],
      state_province: attrs[:state_province],
      country: attrs[:country],
      date_of_birth: attrs[:date_of_birth],
      password: SecureRandom.hex(17),
      email_confirmed_at: Time.current,
      skip_existing_password: true,
    )

    if background_check.present?
      account.create_background_check!({
        candidate_id: background_check.candidate_id,
        report_id: background_check.report_id,
        status: background_check.status,
      })
    end

    account.create_regional_ambassador_profile!(
      organization_company_name: attrs[:organization_company_name],
      job_title: attrs[:job_title],
      bio: attrs[:bio],
      ambassador_since_year: "I'm new!",
      status: :approved,
    )

    attempt
  end
end
