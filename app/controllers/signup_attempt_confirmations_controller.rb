class SignupAttemptConfirmationsController < ApplicationController
  before_action :require_unauthenticated

  def new
    signup_attempt = SignupAttempt.find_by!(activation_token: params.fetch(:token))
    if signup_attempt.registered?
      render "signups/email_taken",
        locals: {
          email: signup_attempt.email
        } and return
    end
    signup_attempt.active!
    cookies[:signup_token] = signup_attempt.signup_token
    redirect_to signup_path, success: t("controllers.signup_attempt_confirmations.new.success")
  end
end
