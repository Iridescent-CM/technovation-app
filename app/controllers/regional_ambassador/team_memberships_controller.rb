module RegionalAmbassador
  class TeamMembershipsController < RegionalAmbassadorController
    def destroy
      team = Team.find(params.fetch(:id))
      account = Account.find(params.fetch(:account_id))

      TeamRosterManaging.remove(
        team,
        account.mentor_profile || account.student_profile
      )

      redirect_to regional_ambassador_team_path(team),
        success: "You have removed #{account.full_name} from this team"
    end
  end
end
