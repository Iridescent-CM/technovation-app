module Mentor
  class TeamsController < MentorController
    def index
      @teams = current_mentor.teams
    end

    def new
      @team = Team.new
    end

    def show
      @team = current_mentor.teams.find(params.fetch(:id))
      @team_member_invite = TeamMemberInvite.new
    end

    def create
      @team = Team.new(team_params)

      if @team.save
        redirect_to [:mentor, @team],
                    success: t("controllers.mentor.teams.create.success")
      else
        render :new
      end
    end

    private
    def team_params
      params.require(:team).permit(:name, :description).tap do |params|
        params[:division] = Division.for(current_mentor)
        params[:mentor_ids] = current_mentor.id
      end
    end
  end
end
