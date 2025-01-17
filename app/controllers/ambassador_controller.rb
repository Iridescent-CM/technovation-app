class AmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_ambassador, :current_chapterable, :current_profile

  before_action -> {
    set_last_profile_used(current_scope)

    params.permit!
  }, if: -> { current_ambassador.authenticated? }

  before_action :require_chapter_and_chapter_ambassador_onboarded,
    if: -> { current_ambassador.chapter_ambassador? && current_ambassador.authenticated? }

  around_action :set_time_zone,
    if: -> { current_ambassador.authenticated? }

  # For Airbrake Notifier
  def current_user
    current_ambassador.account
  end

  def current_scope
    if current_ambassador.chapter_ambassador?
      "chapter_ambassador"
    elsif current_ambassador.club_ambassador?
      "club_ambassador"
    end
  end

  private

  def set_time_zone(&)
    Time.use_zone(current_ambassador.timezone, &)
  end

  def current_ambassador
    @current_ambassador ||= if current_account.chapter_ambassador?
      current_account.chapter_ambassador_profile || current_session.chapter_ambassador_profile
    elsif current_account.club_ambassador?
      current_account.club_ambassador_profile || current_session.club_ambassador_profile
    end
  end

  def current_chapterable
    @current_chapterable ||= current_ambassador.chapter ||
      current_ambassador.club ||
      ::NullChapter.new
  end

  def current_profile
    current_ambassador
  end

  def current_profile_type
    if current_ambassador.chapter_ambassador?
      "ChapterAmbassadorProfile"
    elsif current_ambassador.club_ambassador?
      "ClubAmbassadorProfile"
    end
  end

  def require_chapter_and_chapter_ambassador_onboarded
    return if current_ambassador.club_ambassador?

    unless current_ambassador.chapter&.onboarded? && current_ambassador.onboarded?
      redirect_to chapter_ambassador_dashboard_path,
        error: "You must complete all onboarding tasks before accessing Chapter Admin Activity."
    end
  end
end
