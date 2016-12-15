class RegionalAmbassadorController < ApplicationController
  include Authenticated

  layout "regional_ambassador"
  helper_method :current_ambassador

  private
  def current_ambassador
    @current_ambassador ||= current_account.regional_ambassador_profile
  end

  def model_name
    "regional_ambassador"
  end
end
