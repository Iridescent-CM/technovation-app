module Student
  class HonorCodesController < StudentController
    def show
      if current_team.submission.present?
        redirect_to student_team_submission_path(
          current_team.submission,
          piece: :honor_code
        )
      else
        redirect_to new_student_team_submission_path
      end
    end
  end
end
