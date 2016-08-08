module Signup
  def new
    instance_variable_set("@#{model_name}", registration_helper.build(model, email: params[:email]))
  end

  def create
    instance_variable_set("@#{model_name}", registration_helper.build(model, account_params))

    if registration_helper.(instance, self)
      SignIn.(instance, self, redirect_to: send("#{model_name}_dashboard_path"),
                              message: t("controllers.signups.create.success"))
    else
      render :new
    end
  end

  private
  def account_params
    params.require("#{model_name}_account").permit(
      :email,
      :existing_password,
      :password,
      :password_confirmation,
      :date_of_birth,
      :first_name,
      :last_name,
      :city,
      :state_province,
      :country,
      "#{model_name}_profile_attributes" => %i{id} + profile_params,
    )
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
end
