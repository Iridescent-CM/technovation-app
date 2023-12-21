module Mentor
  class TeamMembershipsController < MentorController
    def destroy
      team = current_mentor.teams.find(params.fetch(:id))

      membership = team.memberships.find_by(
        member_type: params.fetch(:member_type) { "MentorProfile" },
        member_id: params.fetch(:member_id)
      )

      if CanRemoveTeamMember.call(current_account, membership.member)
        TeamRosterManaging.remove(team, membership.member)

        redirect_to mentor_dashboard_path,
          success: t("controllers.team_memberships.destroy.success",
            name: team.name)
      else
        redirect_to mentor_dashboard_path,
          error: "You don't have permission to remove that person."
      end
    end
  end
end
