module Student
  class TeamMembershipsController < StudentController
    def destroy
      team = current_student.teams.find(params.fetch(:id))
      membership = Membership.find_by(joinable: team,
                                      member_type: "StudentAccount",
                                      member_id: current_student.id)

      membership.destroy

      redirect_to student_dashboard_path,
        success: t("controllers.student.team_memberships.destroy.success",
                   name: team.name)
    end
  end
end
