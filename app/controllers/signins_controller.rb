class SigninsController < ApplicationController
  before_action :require_unauthenticated, except: :destroy
  layout "application_rebrand"

  def new
    @signin = Account.new(email: params[:email])
  end

  def create
    submitted_email = signin_params.fetch(:email)
    submitted_password = signin_params.fetch(:password)
    attempted_email = submitted_email.to_s.strip.downcase

    @signin = Account.where(
      "lower(trim(both ' ' from replace(accounts.email, '.', ''))) = ?",
      submitted_email.strip.downcase.delete(".")
    ).first

    if @signin&.locked?
      render_locked(submitted_email)
      return
    end

    if @signin.present? && submitted_password.present? && @signin.authenticate(submitted_password)
      SignIn.call(@signin, self, permanent: params[:remember_me] == "1")
      return
    end

    if @signin.present? && submitted_password.present?
      account_for_failure = @signin
      account_for_failure.register_failed_attempt!(request: request)
      SecurityEventLogger.log(
        event_type: "login.failure",
        account: account_for_failure,
        request: request,
        metadata: {email: attempted_email}
      )

      if account_for_failure.locked?
        render_locked(submitted_email)
        return
      end

      remaining = Account::MAX_FAILED_ATTEMPTS - account_for_failure.failed_attempts
      flash.now[:error] = t(
        "controllers.signins.create.error_with_attempts",
        count: remaining
      )
      @highlight_password_reset = true
    else
      SecurityEventLogger.log(
        event_type: "login.failure",
        account: @signin,
        request: request,
        metadata: {email: attempted_email}
      )
      flash.now[:error] = t("controllers.signins.create.error")
    end

    @signin = Account.new(email: submitted_email)
    render :new
  end

  def destroy
    account = current_account
    if account.present?
      SecurityEventLogger.log(
        event_type: "logout",
        account: account,
        actor: account,
        request: request
      )
    end

    remove_cookie(CookieNames::AUTH_TOKEN)
    remove_cookie(CookieNames::SESSION_TOKEN)
    session.delete(:admin_account_id_performing_impersonation)

    redirect_to login_path, success: t("controllers.signins.destroy.success")
  end

  private

  def render_locked(email)
    flash.now[:error] = t("controllers.signins.create.locked")
    @highlight_password_reset = true
    @signin = Account.new(email: email)
    render :new
  end

  def signin_params
    params.require(:account).permit(:email, :password)
  end
end
