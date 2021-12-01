module RequireLocationIsSet
  extend ActiveSupport::Concern

  included do
    before_action :require_location_is_set
  end

  private

  def require_location_is_set
    redirect_to student_profile_path unless current_student.valid_address?
  end
end
