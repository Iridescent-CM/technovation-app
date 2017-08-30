module Mentor
  class TeamMembershipsController < MentorController
    def destroy
      team = current_mentor.teams.find(params.fetch(:id))
      membership = Membership.find_by(
        team: team,
        member: current_mentor
      )

      membership.destroy

      redirect_to mentor_dashboard_path,
        success: t("controllers.team_memberships.destroy.success",
                   name: team.name)
    end
  end
end
