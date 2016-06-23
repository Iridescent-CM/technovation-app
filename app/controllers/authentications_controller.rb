class AuthenticationsController < ApplicationController
  include AuthenticationController

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
end
