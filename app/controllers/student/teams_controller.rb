module Student
  class TeamsController < StudentController
    include TeamController

    before_action -> {
      if current_student.is_on_team?
        redirect_to student_team_path(current_student.team),
                    alert: t("controllers.student.teams.create.already_on_team")
      else
        true
      end
    }, only: [:create, :new]

    after_action -> {
      current_student.team_member_invites.pending.find_each(&:declined!)
      current_student.join_requests.pending.find_each(&:destroy)
    }, only: :create

    private
    def current_account
      current_student
    end
  end
end
