class SignupAttemptsController < ApplicationController
  before_action :require_unauthenticated

  def create
    existing_attempt = SignupAttempt.where("lower(email) = ?", signup_attempt_params[:email].downcase).last

    if !!existing_attempt
      redirect_to existing_attempt, notice: t("controllers.signup_attempts.create.success") and return
    end

    @signup_attempt = SignupAttempt.new(signup_attempt_params)

    if @signup_attempt.save
      redirect_to @signup_attempt, success: t("controllers.signup_attempts.create.success")
    else
      render "application/dashboards/show"
    end
  end

  def show
    @signup_attempt = SignupAttempt.find(params[:id])
    cookies[:signup_token] = @signup_attempt.signup_token if @signup_attempt.active?
  end

  def update
    @signup_attempt = SignupAttempt.find(params[:id])

    if @signup_attempt.update_attributes(signup_attempt_params)
      redirect_to @signup_attempt, success: t("controllers.signup_attempts.update.success")
    else
      render :show
    end
  end

  private
  def signup_attempt_params
    params.require(:signup_attempt).permit(:email)
  end
end
