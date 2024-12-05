class ClubAmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_club_ambassador,
    :current_profile, :current_club

  before_action -> {
    set_last_profile_used("club_ambassador")
    params.permit!
  }, if: -> { current_club_ambassador.authenticated? }

  around_action :set_time_zone,
    if: -> { current_club_ambassador.authenticated? }

  # For Airbrake Notifier
  def current_user
    current_club_ambassador.account
  end

  def current_scope
    "club_ambassador"
  end

  private

  def set_time_zone(&block)
    Time.use_zone(current_club_ambassador.timezone, &block)
  end

  def current_profile
    current_club_ambassador
  end

  def current_club_ambassador
    @current_club_ambassador ||= current_account.club_ambassador_profile ||
      current_session.club_ambassador_profile
  end

  def current_club
    @current_club ||= current_club_ambassador.club || ::NullClub.new
  end

  def club_ambassador
    current_club_ambassador
  end

  def current_profile_type
    "ClubAmbassadorProfile"
  end
end
