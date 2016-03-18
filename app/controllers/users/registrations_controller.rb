class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
before_filter :registration_override, if: :registration_protected?
before_action :check_registration_opened
  # GET /resource/sign_up
  def new
    super do |resource|
      if params[:role].present?
        if params[:role] != 'judge' && Rails.application.config.env[:registration][:judge_only]
          redirect_to controller: 'users/registrations', action: 'new', role: nil
          return
        else
          resource.role = params[:role]
          return
        end
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

  private

  def check_registration_opened
    return true if params[:role].nil?
    unless Setting.registrationOpen? params[:role]
      redirect_to :new_user_without_role
    end
  end
end
