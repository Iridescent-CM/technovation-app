module Mentor
  class TeamMembershipsController < MentorController
    def destroy
      team = current_mentor.teams.find(params.fetch(:id))
      membership = Membership.find_by(joinable: team,
                                      member_type: "MentorAccount",
                                      member_id: current_mentor.id)

      membership.destroy

      redirect_to mentor_dashboard_path,
        success: t("controllers.mentor.team_memberships.destroy.success",
                   name: team.name)
    end
  end
end
