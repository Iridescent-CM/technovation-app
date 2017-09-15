module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      @students = StudentProfile.in_region(current_ambassador)
        .includes(:team_member_invites, :join_requests)

      @unmatched_students = @students.unmatched
        .order(updated_at: :desc)
        .limit(5)

      @mentors = MentorProfile.in_region(current_ambassador)
        .includes(:mentor_invites, :join_requests)

      @unmatched_mentors = @mentors.unmatched
        .order(updated_at: :desc)
        .limit(5)
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
