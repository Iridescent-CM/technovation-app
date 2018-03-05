module RegionalAmbassador
  class TeamMembershipsController < RegionalAmbassadorController
    def create
      team = Team.find(params.fetch(:team_id))
      account = Account.find(params.fetch(:account_id))

      profile = account.mentor_profile || account.student_profile

      TeamRosterManaging.add(team, profile)

      msg = if team.members.include?(profile)
              {
                success: "You have added #{account.full_name} " +
                         "to #{team.name}",
              }
            elsif account.student_profile
              { alert: team.errors[:add_student][0] }
            else
              { alert: "An error occurred." }
            end

      redirect_to regional_ambassador_participant_path(account), msg
    end

    def destroy
      team = Team.find(params.fetch(:id))
      account = Account.find(params.fetch(:account_id))

      TeamRosterManaging.remove(
        team,
        account.mentor_profile || account.student_profile
      )

      redirect_to regional_ambassador_team_path(
        team,
        allow_out_of_region: params.fetch(:allow_out_of_region) { false }
      ),
        success: "You have removed #{account.full_name} from this team"
    end
  end
end
