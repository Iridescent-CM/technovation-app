module Student
  class TeamsController < StudentController
    def show
      @team = current_student.teams.find(params.fetch(:id))
    end

    def new
      @team = Team.new
    end

    def create
      membership = current_student.memberships.build(joinable: Team.new(team_params.merge(division: Division.for(current_student))))

      if membership.save
        redirect_to [:student, membership.joinable], success: t("controllers.student.teams.create.success")
      else
        @team = membership.joinable
        render :new
      end
    end

    private
    def team_params
      params.require(:team).permit(:name, :description)
    end
  end
end
