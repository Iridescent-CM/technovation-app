module Admin
  class TeamMembershipsController < AdminController
    def destroy
      team = Team.find(params.fetch(:id))
      account = Account.find(params.fetch(:account_id))

      if account.mentor_profile
        team.remove_mentor(account.mentor_profile)
      else
        team.remove_student(account.student_profile)
      end

      redirect_to admin_team_path(team),
        success: "You have removed #{account.full_name} from this team"
    end

    def create
    end

  end
end
