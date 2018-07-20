module ShowSignupAttempt
  def self.call(pending_token, callbacks)
    token = pending_token[0..23]
    attempt = SignupAttempt.find_by(pending_token: token)

    if attempt.temporary_password?
      RegistrationMailer.confirm_email(attempt).deliver_later
    end

    callbacks[:success].call(attempt)
  end
end