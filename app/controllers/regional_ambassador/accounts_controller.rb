module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      @unmatched_students = StudentProfile.unmatched
        .in_region(current_ambassador)
        .includes(:team_member_invites, :join_requests)
        .order(updated_at: :desc)
        .limit(15)

      @unmatched_mentors = MentorProfile.unmatched
        .in_region(current_ambassador)
        .includes(:mentor_invites, :join_requests)
        .order(updated_at: :desc)
        .limit(15)

      @teams_without_students = Team.unmatched(:students)
        .in_region(current_ambassador)
        .includes(:team_member_invites, :join_requests)
        .order(updated_at: :desc)
        .limit(15)

      @teams_without_mentors = Team.unmatched(:mentors)
        .in_region(current_ambassador)
        .includes(:team_member_invites, :join_requests)
        .order(updated_at: :desc)
        .limit(15)
    end

    def show
      @account = Account.find(params[:id])
    end

    private
    def accounts_grid_params
      params.fetch(:accounts_grid) { {} }.merge(ambassador: current_ambassador)
    end
  end
end
