class RegionalAmbassadorController < ApplicationController
  include Authenticated

  layout "regional_ambassador"
  helper_method :current_ambassador

  before_action -> {
    current_ambassador.timezone ||= Timezone.lookup(current_ambassador.latitude, current_ambassador.longitude).name
    Time.zone = current_ambassador.timezone
  }

  private
  def current_ambassador
    @current_ambassador ||= current_account.regional_ambassador_profile
  end

  def model_name
    "regional_ambassador"
  end
end
