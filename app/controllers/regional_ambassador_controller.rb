class RegionalAmbassadorController < ApplicationController
  include Authenticated

  layout "regional_ambassador"
  helper_method :current_ambassador

  private
  def current_ambassador
    @current_ambassador ||= RegionalAmbassadorProfile.joins(:account)
      .find_by("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" }) ||
    Account::NoAuthFound.new
  end

  def model_name
    "regional_ambassador"
  end
end
