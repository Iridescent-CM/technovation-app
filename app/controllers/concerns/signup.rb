module Signup
  def new
    instance_variable_set("@#{model_name}", model.new(email: params[:email]))
  end

  def create
    instance_variable_set("@#{model_name}", model.new(account_params))

    if instance.save
      SignIn.(instance, self, redirect: send("#{model_name}_dashboard_path"))
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
end
