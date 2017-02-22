class SignupAttemptsController < ApplicationController
  before_action :require_unauthenticated

  def create
    if valid_credentials_for_sign_in?
      SignIn.(existing_account, self)

    elsif valid_email_for_existing_account?
      redirect_to signin_path(email: existing_account.email), error: t("controllers.signins.create.error")

    elsif attempt_exists?
      redirect_to signup_attempt_path(existing_attempt.pending_token), notice: t("controllers.signup_attempts.create.success")

    elsif current_signup_attempt.save
      redirect_to signup_attempt_path(current_signup_attempt.pending_token), success: t("controllers.signup_attempts.create.success")

    else
      render "application/dashboards/show"
    end
  end

  def show
    @signup_attempt = SignupAttempt.find_by(pending_token: params[:id])
    RegistrationMailer.confirm_email(@signup_attempt).deliver_later if @signup_attempt.temporary_password?
    cookies[:signup_token] = @signup_attempt.signup_token if @signup_attempt.active?
  end

  def update
    @signup_attempt = SignupAttempt.find_by(pending_token: params[:id])

    if @signup_attempt.update_attributes(signup_attempt_params)
      redirect_to signup_attempt_path(@signup_attempt.pending_token), success: t("controllers.signup_attempts.update.success")
    else
      render :show
    end
  end

  private
  def valid_credentials_for_sign_in?
     valid_email_for_existing_account? and existing_account.authenticate(signup_attempt_params.fetch(:password))
  end

  def existing_account
    @existing_account ||= Account.where(
      "lower(email) = ?",
      signup_attempt_params[:email].downcase
    ).last
  end

  def valid_email_for_existing_account?
    !!existing_account
  end

  def attempt_exists?
    !!existing_attempt
  end

  def existing_attempt
   @existing_attempt ||= SignupAttempt.where(
     "lower(email) = ?",
     signup_attempt_params[:email].downcase
   ).last
  end

  def current_signup_attempt
    @signup_attempt ||= SignupAttempt.new(signup_attempt_params)
  end

  def signup_attempt_params
    params.require(:signup_attempt).permit(:email, :password)
  end
end
