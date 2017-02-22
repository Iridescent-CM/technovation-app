module CreateSignupAttempt
  def self.call(params, callbacks)
    @existing_account = Account.where(
      "lower(email) = ?",
      params[:email].downcase
    ).last

    @existing_attempt = SignupAttempt.where(
      "lower(email) = ?",
      params[:email].downcase
    ).last

    @signup_attempt = SignupAttempt.new(params)

    if valid_credentials_for_sign_in?(params)
      callbacks[:valid_credentials].call(@existing_account)

    elsif valid_email_for_existing_account?
      callbacks[:existing_account].call(@existing_account)

    elsif attempt_exists?
      callbacks[:existing_attempt].call(@existing_attempt)

    elsif @signup_attempt.save
      RegistrationMailer.confirm_email(@signup_attempt).deliver_later
      callbacks[:success].call(@signup_attempt)

    else
      callbacks[:error].call(@signup_attempt)
    end
  end

  private
  def self.valid_credentials_for_sign_in?(params)
     valid_email_for_existing_account? and
       @existing_account.authenticate(params.fetch(:password))
  end

  def self.valid_email_for_existing_account?
    !!@existing_account
  end

  def self.attempt_exists?
    !!@existing_attempt
  end
end
