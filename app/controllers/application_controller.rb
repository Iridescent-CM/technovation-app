class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, {except: :index, unless: :special_controller?}
  before_action :verify_consent, {unless: :special_controller?}

  def special_controller?
    # since the admin user class is currently seperate from the main devise class,
    # we need to make sure that pundit doesn't run on these controllers
    self.class.name.starts_with?('Admin::') || devise_controller?
  end


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
