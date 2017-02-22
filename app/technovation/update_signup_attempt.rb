module UpdateSignupAttempt
  def self.call(pending_token, params, callbacks)
    attempt = SignupAttempt.find_by(pending_token: pending_token)

    if attempt.update_attributes(params)
      if attempt.status_changed? and attempt.active?
        attempt.regenerate_signup_token
      elsif attempt.pending?
        RegistrationMailer.confirm_email(attempt).deliver_later
      end

      callbacks[:success].call(attempt)
    else
      callbacks[:error].call(attempt)
    end
  end
end
