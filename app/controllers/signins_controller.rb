class SigninsController < ApplicationController
  layout 'public_dashboard'
  before_action :require_unauthenticated, except: :destroy

  def new
    @signin = Account.new(email: params[:email])
  end

  def create
    @signin = Account.where(
      "lower(trim(both ' ' from replace(accounts.email, '.', ''))) = ?",
      signin_params.fetch(:email).strip.downcase.gsub('.', '')
    ).first

    if !!@signin && !!@signin.authenticate(signin_params.fetch(:password))
      SignIn.(@signin, self, permanent: params[:remember_me] == "1")
    else
      @signin = Account.new
      flash.now[:error] = t('controllers.signins.create.error')
      render :new
    end
  end

  def destroy
    remove_cookie(CookieNames::AUTH_TOKEN)
    remove_cookie(CookieNames::SESSION_TOKEN)
    redirect_to login_path, success: t('controllers.signins.destroy.success')
  end

  private
  def signin_params
    params.require(:account).permit(:email, :password)
  end
end
