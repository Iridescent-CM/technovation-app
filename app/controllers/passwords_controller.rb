class PasswordsController < ApplicationController
  def new
    @password = Password.find_by(token: params.fetch(:token))
    unless @password.valid?
      return redirect_to new_password_reset_path, alert: alert_message(@password)
    end
  end

  def create
    @password = Password.new(password_params)
    if @password.valid?
      @password.perform
      SignIn.(@password.account, self,
              message: t("controllers.passwords.create.success"))
    else
      render :new
    end
  end

  private
  def alert_message(password)
    if password.errors.keys.include?(:expires_at)
      t("controllers.passwords.new.expired")
    else
      t("controllers.passwords.new.invalid")
    end
  end

  def password_params
    params.require(:password).permit(
      :password,
      :password_confirmation,
      :token
    ).tap do |p|
      p[:resetting] = true
    end
  end
end
