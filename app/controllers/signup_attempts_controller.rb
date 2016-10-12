class SignupAttemptsController < ApplicationController
  before_action :require_unauthenticated

  def create
    existing_attempt = SignupAttempt.where("lower(email) = ?", signup_attempt_params[:email].downcase).last
    existing_account = Account.where("lower(email) = ?", signup_attempt_params[:email].downcase).last

    @signup_attempt = SignupAttempt.new(signup_attempt_params)

    if !!existing_attempt
      redirect_to signup_attempt_path(existing_attempt.pending_token), notice: t("controllers.signup_attempts.create.success")
    elsif !!existing_account
      render :show
    elsif @signup_attempt.save
      redirect_to signup_attempt_path(@signup_attempt.pending_token), success: t("controllers.signup_attempts.create.success")
    else
      render "application/dashboards/show"
    end
  end

  def show
    @signup_attempt = SignupAttempt.find_by(pending_token: params[:id])
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
  def signup_attempt_params
    params.require(:signup_attempt).permit(:email)
  end
end
