module Admin
  class TeamMembershipsController < AdminController
    def destroy
      team = Team.find(params.fetch(:id))
      account = Account.find(params.fetch(:account_id))

      if account.mentor_profile
        TeamRosterManaging.remove(team, account.mentor_profile)
      else
        TeamRosterManaging.remove(team, account.student_profile)
      end

      redirect_to admin_team_path(team),
        success: "You have removed #{account.full_name} from this team"
    end

    def create
      team = Team.find(params.fetch(:team_id))
      account = Account.find(params.fetch(:account_id))

      if account.mentor_profile
        team.add_mentor(account.mentor_profile)
      else
        team.add_student(account.student_profile)
      end

      msg = if team.members.include?(account.mentor_profile || account.student_profile)
              { success: "You have added #{account.full_name} to this team" }
            elsif account.student_profile
              { alert: team.errors[:add_student][0] }
            else
              { alert: "An error occurred." }
            end

      redirect_to admin_profile_path(account), msg
    end

  end
end
