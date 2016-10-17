module SignupController
  extend ActiveSupport::Concern

  included do
    before_action :require_unauthenticated
  end

  def new
    if token = cookies[:signup_token]
      email = SignupAttempt.find_by!(signup_token: token).email
      instance_variable_set("@#{model_name}", registration_helper.build(model, email: email))
    else
      redirect_to root_path
    end
  end

  def create
    instance_variable_set("@#{model_name}", registration_helper.build(model, account_params))

    if registration_helper.(instance, self)
      cookies.delete(:signup_token)
      SignIn.(instance, self, redirect_to: after_signup_path,
                              message: t("controllers.signups.create.success"))
    else
      render :new
    end
  end

  private
  def account_params
    params.require("#{model_name}_account").permit(
      :email,
      :password,
      :date_of_birth,
      :first_name,
      :last_name,
      :gender,
      :geocoded,
      :city,
      :state_province,
      :country,
      :latitude,
      :longitude,
      :referred_by,
      :referred_by_other,
      "#{model_name}_profile_attributes" => %i{id} + profile_params,
    ).tap do |tapped|
      attempt = SignupAttempt.find_by!(signup_token: cookies.fetch(:signup_token))
      tapped[:email] = attempt.email

      unless attempt.temporary_password?
        tapped[:password_digest] = attempt.password_digest
      end
    end
  end

  def model
    "#{model_name}_account".camelize.constantize
  end

  def instance
    instance_variable_get("@#{model_name}")
  end

  def registration_helper
    "register_#{model_name}".camelize.constantize
  end

  def after_signup_path
    send("#{model_name}_dashboard_path")
  end
end
