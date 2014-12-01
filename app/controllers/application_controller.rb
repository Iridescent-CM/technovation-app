class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :verify_consent, {unless: :devise_controller?}
  protect_from_forgery with: :exception
  after_action :verify_authorized, {except: :index, unless: :devise_controller?}
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected
  def verify_consent
    if current_user != nil and current_user.consent_signed_at.nil?
        return redirect_to controller: '/signature', action: :status
    end
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def configure_devise_permitted_parameters
    registration_params = [
      :avatar,
      :role,
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :birthday,
      :home_city,
      :home_state,
      :home_country,
      :postal_code,
      :school,
      :grade  ,
      :parent_first_name,
      :parent_last_name,
      :parent_phone,
      :parent_email,

      :salutation,
      :science,
      :engineering,
      :project_management,
      :finance,
      :marketing,
      :design,
      :connect_with_other,

      :referral_category,
      :referral_details,
    ]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(registration_params)
      }
    end
  end
end
