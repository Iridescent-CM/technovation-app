module Student
  class TeamsController < StudentController
    def show
      @team = current_student.teams.find(params.fetch(:id))
      @team_member_invite = TeamMemberInvite.new
    end

    def new
      @team = Team.new
    end

    def create
      @team = Team.new(team_params)

      if @team.save
        redirect_to [:student, @team],
                    success: t("controllers.student.teams.create.success")
      else
        render :new
      end
    end

    private
    def team_params
      params.require(:team).permit(:name, :description).tap do |params|
        params[:division] = Division.for(current_student)
        params[:student_ids] = current_student.id
      end
    end
  end
end
