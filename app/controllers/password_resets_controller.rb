class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(password_reset_params)

    if @password_reset.valid?
      @password_reset.perform
      redirect_to signin_path, success: t("controllers.password_resets.create.success")
    else
      flash.now[:alert] = t("controllers.password_resets.create.failure")
      render :new
    end
  end

  private
  def password_reset_params
    params.require(:password_reset).permit(:email)
  end
end
