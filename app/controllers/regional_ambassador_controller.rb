class RegionalAmbassadorController < ApplicationController
  include Authenticated

  layout "regional_ambassador"
  helper_method :current_ambassador

  before_action -> {
    if current_ambassador.timezone.blank? and current_ambassador.location_confirmed?
      current_ambassador.account.update_column(:timezone, Timezone.lookup(current_ambassador.latitude, current_ambassador.longitude).name)
    end
  }

  around_action :set_time_zone, if: -> { current_ambassador.authenticated? }

  # For Airbrake Notifier
  def current_user
    current_ambassador
  end

  private
  def set_time_zone(&block)
    Time.use_zone(current_ambassador.timezone, &block)
  end

  def current_ambassador
    @current_ambassador ||= current_account.regional_ambassador_profile
  end

  def model_name
    "regional_ambassador"
  end
end
