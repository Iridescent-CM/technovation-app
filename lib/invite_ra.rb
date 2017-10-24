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

    account.create_regional_ambassador_profile!(
      organization_company_name: attrs[:organization_company_name],
      job_title: attrs[:job_title],
      bio: attrs[:bio],
      ambassador_since_year: "I'm new!",
      status: :approved,
    )

    RegistrationMailer.admin_permission(attempt.id).deliver_now

    attempt
  end
end
