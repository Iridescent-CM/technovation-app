class AttachSignupAttemptJob < ActiveJob::Base
  queue_as :default

  def perform(account)
    if attempt = SignupAttempt.find_by(email: account.email)
      attempt.update_column(:account_id, account.id)
      attempt.registered!
    end
  end
end
