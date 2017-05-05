module RegionalAmbassador
  class TeamMembershipsController < RegionalAmbassadorController
    def destroy
      team = Team.find(params.fetch(:id))
      account = Account.find(params.fetch(:account_id))

      if account.mentor_profile
        team.remove_mentor(account.mentor_profile)
      else
        team.remove_student(account.student_profile)
      end

      redirect_to regional_ambassador_team_path(team),
        success: "You have removed #{account.full_name} from this team"
    end
  end
end
