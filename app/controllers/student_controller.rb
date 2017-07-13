class StudentController < ApplicationController
  include Authenticated

  layout "student"
  helper_method :current_student, :current_team

  before_action -> {
    unless current_student.honor_code_signed?
      save_redirected_path
      redirect_to interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{interruptions
      location_details
      cookies
      profiles
      honor_code_agreements
      dashboards
      parental_consent_notices
    }.include?(controller_name)
  }

  # For Airbrake Notifier
  def current_user
    current_account
  end

  private
  def require_full_access
    if current_student.full_access_enabled?
      true
    else
      redirect_to student_dashboard_path,
        notice: t("controllers.application.full_access_required")
    end
  end

  def require_current_team
    if current_team.present?
      true
    else
      redirect_to student_dashboard_path,
        notice: t("controllers.application.team_required")
    end
  end

  def current_student
    @current_student ||= current_account.student_profile
  end

  def current_team
    current_student.team
  end

  def model_name
    "student"
  end
  alias :user_scope :model_name
end
