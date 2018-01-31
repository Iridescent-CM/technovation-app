class RegionalAmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_ambassador,
    :current_profile

  before_action -> {
    set_last_profile_used("regional_ambassador")
    params.permit!
  }, if: -> { current_ambassador.authenticated? }

  around_action :set_time_zone,
    if: -> { current_ambassador.authenticated? }

  # For Airbrake Notifier
  def current_user
    current_ambassador.account
  end

  def current_scope
    "regional_ambassador"
  end

  private
  def set_time_zone(&block)
    Time.use_zone(current_ambassador.timezone, &block)
  end

  def current_profile
    current_ambassador
  end

  def current_ambassador
    @current_ambassador ||= current_account.regional_ambassador_profile ||
      current_session.regional_ambassador_profile
  end

  def regional_ambassador
    current_ambassador
  end

  def current_profile_type
    "RegionalAmbassadorProfile"
  end
end
