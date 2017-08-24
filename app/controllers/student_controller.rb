class StudentController < ApplicationController
  include Authenticated

  layout "student"
  helper_method :current_student, :current_team

  # For Airbrake Notifier
  def current_user
    current_account
  end

  def current_scope
    "student"
  end

  def current_team
    current_student.team
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
end
