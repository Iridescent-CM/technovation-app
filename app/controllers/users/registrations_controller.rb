class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
before_filter :registration_override, if: :registration_protected?

  # GET /resource/sign_up
  def new
    super do |resource|
      if params[:role].present?
        resource.role = params[:role]
      else
        render 'devise/registrations/choose'
        return
      end
    end
  end

  def registration_protected?
    !Rails.application.config.env[:registration][:open] && 
      Rails.application.config.env[:registration][:override_username] &&
      Rails.application.config.env[:registration][:override_password]
  end

  def registration_override
    login = authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.config.env[:registration][:override_username] &&
        Digest::SHA1.hexdigest(password) == Rails.application.config.env[:registration][:override_password]
    end
    session[:registration_override] = login
  end

  # POST /resource

  # def new
  #   super
  # end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
