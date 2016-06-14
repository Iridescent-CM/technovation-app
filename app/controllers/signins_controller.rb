class SigninsController < ApplicationController
  def new
    @signin = Signin.new
  end

  def create
    @signin = Signin.find_by(email: signin_params.fetch(:email))

    if !!@signin && !!@signin.authenticate(signin_params.fetch(:password))
      sign_in(@signin)
    else
      @signin = Signin.new
      flash[:error] = t('controllers.signins.create.error')
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, success: t('controllers.signins.destroy.success')
  end

  private
  def signin_params
    params.require(:signin).permit(:email, :password)
  end
end
