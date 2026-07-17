class SigninsController < ApplicationController
  before_action :require_unauthenticated, except: :destroy
  layout "application_rebrand"

  def new
    @signin = Account.new(email: params[:email])
  end

  def create
    submitted_email = signin_params.fetch(:email)
    submitted_password = signin_params.fetch(:password)

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
      @signin.register_failed_attempt!

      if @signin.locked?
        render_locked(submitted_email)
        return
      end

      remaining = Account::MAX_FAILED_ATTEMPTS - @signin.failed_attempts
      flash.now[:error] = t(
        "controllers.signins.create.error_with_attempts",
        count: remaining
      )
      @highlight_password_reset = true
    else
      flash.now[:error] = t("controllers.signins.create.error")
    end

    @signin = Account.new(email: submitted_email)
    render :new
  end

  def destroy
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
