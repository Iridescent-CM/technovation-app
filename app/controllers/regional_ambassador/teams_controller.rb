module RegionalAmbassador
  class TeamsController < RegionalAmbassadorController
    def index
      @teams = Team.in_region(current_ambassador)
        .includes(:team_member_invites, :join_requests)

      @teams_without_students = @teams.unmatched(:students)
        .order(updated_at: :desc)
        .limit(5)

      @teams_without_mentors = @teams.unmatched(:mentors)
        .order(updated_at: :desc)
        .limit(5)
    end

    def show
      @team = Team.find(params[:id])
    end
  end
end
