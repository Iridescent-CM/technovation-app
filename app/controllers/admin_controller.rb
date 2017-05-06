class AdminController < ApplicationController
  include Authenticated

  layout 'admin'

  helper_method :current_admin

  before_action -> {
    cookies.permanent[:export_email] ||= "info@technovationchallenge.org"
    params.permit!
  }

  def current_user
    current_admin.account
  end

  private
  def current_admin
    @current_admin ||= current_account.admin_profile
  end

  def model_name
    "admin"
  end
end
