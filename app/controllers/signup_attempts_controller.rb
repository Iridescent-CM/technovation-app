class SignupAttemptsController < ApplicationController
  before_action :require_unauthenticated

  def create
    CreateSignupAttempt.(signup_attempt_params, {
      valid_credentials: ->(account) {
        SignIn.(account, self)
      },

      existing_account: ->(account) {
        redirect_to signin_path(email: account.email),
          error: t("controllers.signins.create.error")
      },

      existing_attempt: ->(attempt) {
        redirect_to signup_attempt_path(attempt.pending_token),
          notice: t("controllers.signup_attempts.create.success")
      },

      success: ->(attempt) {
        redirect_to signup_attempt_path(attempt.pending_token),
          success: t("controllers.signup_attempts.create.success")
      },

      error: ->(attempt) {
        @signup_attempt = attempt
        render "application/dashboards/show"
      }
    })
  end

  def show
    ShowSignupAttempt.(params[:id], {
      success: ->(attempt) {
        @signup_attempt = attempt

        if @signup_attempt.active?
          cookies[:signup_token] = @signup_attempt.signup_token
        end
      }
    })
  end

  def update
    UpdateSignupAttempt.(params[:id], signup_attempt_params, {
      success: ->(attempt) {
        redirect_to signup_attempt_path(attempt.pending_token),
          success: t("controllers.signup_attempts.update.success")
      },

      error: ->(attempt) {
        @signup_attempt = attempt
        render :show
      }
    })
  end

  private
  def signup_attempt_params
    params.require(:signup_attempt).permit(:email, :password)
  end
end
