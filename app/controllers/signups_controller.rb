class SignupsController < ApplicationController
  def new
    instance_variable_set("@#{model_name}", model.new)
  end

  def create
    instance_variable_set("@#{model_name}", model.new(account_params))

    if instance.save
      sign_in(instance, redirect: student_dashboard_path,
                        message: t("controllers.student.signups.create.success"))
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
      :region,
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
