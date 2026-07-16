class SigninsController < ApplicationController
  before_action :require_unauthenticated, except: :destroy
  layout "application_rebrand"

  def new
    @signin = Account.new(email: params[:email])
  end

  def create
    @signin = Account.where(
      "lower(trim(both ' ' from replace(accounts.email, '.', ''))) = ?",
      signin_params.fetch(:email).strip.downcase.delete(".")
    ).first

    if @signin&.locked?
      flash.now[:error] = t("controllers.signins.create.locked")
      render :new
      return
    end

    if !!@signin && !!@signin.authenticate(signin_params.fetch(:password))
      SignIn.call(@signin, self, permanent: params[:remember_me] == "1")
    else
      account_for_failure = @signin
      attempted_email = signin_params.fetch(:email).to_s.strip.downcase
      @signin = Account.new
      account_for_failure&.register_failed_attempt!(request: request)
      SecurityEventLogger.log(
        event_type: "login.failure",
        account: account_for_failure,
        request: request,
        metadata: {email: attempted_email}
      )
      flash.now[:error] = t("controllers.signins.create.error")
      render :new
    end
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

  def signin_params
    params.require(:account).permit(:email, :password)
  end
end
