class LocaleSwitchesController < ApplicationController
  include Authenticated

  def create
    current_account.update_attributes(locale: params[:locale])
    redirect_back fallback_location: send("#{current_account.type_name}_dashboard_path")
  end

  private
  def model_name; end
  def save_redirected_path; end
  def unauthorized!; end
end
