class ChapterAmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_ambassador,
    :current_profile

  before_action -> {
    set_last_profile_used("chapter_ambassador")
    params.permit!
  }, if: -> { current_ambassador.authenticated? }

  around_action :set_time_zone,
    if: -> { current_ambassador.authenticated? }

  # For Airbrake Notifier
  def current_user
    current_ambassador.account
  end

  def current_scope
    "chapter_ambassador"
  end

  private
  def set_time_zone(&block)
    Time.use_zone(current_ambassador.timezone, &block)
  end

  def current_profile
    current_ambassador
  end

  def current_ambassador
    @current_ambassador ||= current_account.chapter_ambassador_profile ||
      current_session.chapter_ambassador_profile
  end

  def chapter_ambassador
    current_ambassador
  end

  def current_profile_type
    "ChapterAmbassadorProfile"
  end
end
