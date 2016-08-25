class Student::JoinRequestsController < StudentController
  def new
    @team = Team.find(params.fetch(:team_id))
  end

  def create
    team = Team.find(params.fetch(:team_id))
    current_student.join_requests.create!(joinable: team)

    redirect_to :back,
      success: t("controllers.student.join_requests.create.success", name: team.name)
  end

  def update
    join_request = JoinRequest.find(params.fetch(:id))
    join_request.public_send("#{params.fetch(:status)}!")

    redirect_to :back, success: t("controllers.student.join_requests.update.success",
                                  name: join_request.requestor_first_name,
                                  status: params.fetch(:status))
  end
end
