module Admin
  class SignupInvitationsController < AdminController
    def create
      if Account.where("LOWER(email) = ?", params[:email].downcase).first
        redirect_back fallback_location: admin_signup_attempts_path,
          alert: "#{params[:email]} already has an account! Have them try resetting their password if they can't sign in." and return
      end

      attempt = SignupAttempt.find_by(email: params[:email])

      unless attempt
        attempt = SignupAttempt.create!(
          email: params[:email],
          password: SecureRandom.hex(17),
          status: SignupAttempt.statuses[:temporary_password]
        )
      end

      attempt.regenerate_admin_permission_token

      RegistrationMailer.admin_permission(attempt).deliver_later

      redirect_back fallback_location: admin_signup_attempts_path,
        success: "#{attempt.email} was sent a special signup inivitation!"
    end
  end
end
