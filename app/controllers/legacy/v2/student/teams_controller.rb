module Legacy
  module V2
    module Student
      class TeamsController < StudentController
        include TeamController

        before_action -> {
          if current_student.is_on_team?
            redirect_to student_team_path(current_student.team),
                        alert: t("controllers.teams.create.already_on_team")
          else
            true
          end
        }, only: [:create, :new]

        after_action -> {
          current_student.team_member_invites.pending.find_each(&:declined!)
          current_student.join_requests.pending.find_each(&:destroy)
        }, only: :create

        def index
          if current_student.is_on_team?
            redirect_to [:student, current_student.team]
          else
            redirect_to [:student, :dashboard]
          end
        end

        private
        def current_profile
          current_student
        end

        def account_type
          "student"
        end
      end
    end
  end
end
