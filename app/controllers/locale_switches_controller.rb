class LocaleSwitchesController < ApplicationController
  include Authenticated

  def create
    current_account.update_attributes(locale: params[:locale])
    redirect_to :back
  end

  private
  def model_name; end
  def save_redirected_path; end
end
