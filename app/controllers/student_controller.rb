class StudentController < ApplicationController
  include Authenticated

  def authenticated_exceptions
    ['team_member_invites#show']
  end

  layout "student"
  helper_method :current_student, :current_team, :current_profile

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
  def require_onboarded
    if current_student.onboarded?
      true
    else
      redirect_to student_dashboard_path,
        notice: t("controllers.application.onboarding_required")
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

  def current_profile
    current_student
  end
end
