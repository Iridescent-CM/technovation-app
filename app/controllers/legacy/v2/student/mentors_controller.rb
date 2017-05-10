module Legacy
  module V2
    class Student::MentorsController < StudentController
      def show
        if current_student.team.present?
          @mentor = MentorProfile.find(params.fetch(:id))
          @mentor_invite = MentorInvite.new
        else
          redirect_to student_dashboard_path,
            alert: t("controllers.student.mentors.show.no_team")
        end
      end
    end
  end
end
