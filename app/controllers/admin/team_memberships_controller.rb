module Admin
  class TeamMembershipsController < AdminController
    def create
      team = Team.find(params.fetch(:team_id))
      account = Account.find(params.fetch(:account_id))

      profile = account.mentor_profile || account.student_profile

      TeamRosterManaging.add(team, profile)

      msg = if team.members.include?(profile)
        {
          success: "You have added #{account.full_name} " +
            "to this team"
        }
      elsif account.student_profile
        {alert: team.errors[:add_student][0]}
      else
        {alert: "An error occurred."}
      end

      redirect_to admin_participant_path(account), msg
    end

    def destroy
      team = Team.find(params.fetch(:id))
      account = team.memberships.find_by(
        member_id: params.fetch(:member_id),
        member_type: params.fetch(:member_type)
      ).member.account

      if account.mentor_profile
        TeamRosterManaging.remove(team, account.mentor_profile)
      else
        TeamRosterManaging.remove(team, account.student_profile)
      end

      redirect_to admin_team_path(team),
        success: "You have removed #{account.full_name} from this team"
    end
  end
end
