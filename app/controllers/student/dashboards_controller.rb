module Student
  class DashboardsController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
    include LocationStorageController

    def show
      if SeasonToggles.display_scores_and_certs?
        redirect_to student_scores_overview_path
      elsif current_student.is_on_team?
        redirect_to student_team_submission_overview_path
      end
    end
  end
end
