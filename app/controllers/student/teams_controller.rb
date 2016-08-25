module Student
  class TeamsController < StudentController
    include TeamController

    before_action :restrict_team_creation,
      only: [:create, :new],
      if: -> { current_student.is_on_team? }

    after_action -> {
      current_student.team_member_invites.pending.each(&:declined!)
      current_student.join_requests.pending.each(&:destroy)
    }, only: :create

    private
    def restrict_team_creation
      redirect_to student_team_path(current_student.team),
        alert: t("controllers.student.teams.create.already_on_team")
    end

    def current_account
      current_student
    end
  end
end
