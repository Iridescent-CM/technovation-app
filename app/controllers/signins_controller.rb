class SigninsController < ApplicationController
  before_action :require_unauthenticated, except: :destroy

  def new
    @signin = Account.new(email: params[:email])
  end

  def create
    @signin = Account.where("lower(email) = ?", signin_params.fetch(:email).downcase).first

    if !!@signin && !!@signin.authenticate(signin_params.fetch(:password))
      SignIn.(@signin, self)
    else
      @signin = Account.new
      flash[:error] = t('controllers.signins.create.error')
      render :new, status: 403
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, success: t('controllers.signins.destroy.success')
  end

  private
  def signin_params
    params.require(:account).permit(:email, :password)
  end
end
