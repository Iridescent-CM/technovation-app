module ShowSignupAttempt
  def self.call(pending_token, callbacks)
    attempt = SignupAttempt.find_by(pending_token: pending_token)

    if attempt.temporary_password?
      RegistrationMailer.confirm_email(attempt).deliver_later
    end

    callbacks[:success].call(attempt)
  end
end
