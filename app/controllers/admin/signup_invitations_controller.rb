module Admin
  class SignupInvitationsController < AdminController
    def create
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

      redirect_to :back, success: "#{attempt.email} was sent a special signup inivitation!"
    end
  end
end
