module VerifyStudentAgeConcern
  extend ActiveSupport::Concern

  included do
    before_action :verify_student_age
  end

  private

  def verify_student_age
    if current_account.authenticated? && current_account.age_by_cutoff > 18 && !currently_on_student_mentor_conversion_page?
      redirect_to student_mentor_conversion_path(id: current_student)
    end
  end

  def currently_on_student_mentor_conversion_page?
    current_request_path = Rails.application.routes.recognize_path(
      request.fullpath,
      method: request.method
    )

    current_request_path == Rails.application.routes.recognize_path(student_mentor_conversion_path)
  end
end
