class RegionalAmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_ambassador, :current_profile

  before_action -> {
    # TODO: move ambassador timezone setting to ProfileUpdating probably
    if current_ambassador.timezone.blank? and
      current_ambassador.location_confirmed?

      current_ambassador.account.update_column(
        :timezone,
        Timezone.lookup(
          current_ambassador.latitude,
          current_ambassador.longitude
        ).name
      )
    end

    if "regional_ambassador" != cookies[:last_profile_used]
      cookies[:last_profile_used] = "regional_ambassador"
    end

    # TODO: we are permitting all params in RA controllers!
    params.permit!
  }

  around_action :set_time_zone, if: -> { current_ambassador.authenticated? }

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
end
