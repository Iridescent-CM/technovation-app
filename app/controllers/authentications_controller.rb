class AuthenticationsController < ApplicationController
  def edit
    authentication
  end

  def update
    if authentication.update_attributes(auth_params)
      redirect_to authentication_path,
                  success: t('controllers.authentications.update.success')
    else
      render :edit
    end
  end

  private
  def authentication
    @authentication ||= Authentication.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def auth_params
    params.require(:authentication).permit(:email, :existing_password,
                                           :password, :confirm_password)
  end
end
