class StudentController < ApplicationController
  include Authenticated
  include VerifyStudentAgeConcern

  layout "student"
  helper_method :current_student,
    :current_team,
    :current_submission,
    :current_profile,
    :back_from_event_path

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

  def current_submission
    current_team.submission
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
    @current_student ||= current_account.student_profile ||
      current_session.student_profile ||
        ::NullProfile.new
  end

  def current_profile
    current_student
  end

  def current_profile_type
    "StudentProfile"
  end

  def back_from_event_path
    student_dashboard_path
  end
end
