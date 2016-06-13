class SigninsController < ApplicationController
  def new
    @signin = Signin.new
  end

  def create
    @signin = Signin.find_by(email: signin_params.fetch(:email))

    if @signin.authenticate(signin_params.fetch(:password))
      cookies[:auth_token] = @signin.auth_token
      redirect_to root_path, success: t('controllers.signins.create.success')
    else
      flash[:error] = t('controllers.signins.create.error')
      render :new
    end
  end

  private
  def signin_params
    params.require(:signin).permit(:email, :password)
  end
end
