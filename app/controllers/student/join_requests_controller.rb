class Student::JoinRequestsController < StudentController
  def new
    @team = Team.find(params.fetch(:team_id))
  end

  def create
    team = Team.find(params.fetch(:team_id))
    current_student.join_requests.create!(joinable: team)

    redirect_back fallback_location: student_team_path(team),
      success: t("controllers.student.join_requests.create.success", name: team.name)
  end

  def update
    status = params.fetch(:status)

    join_request = JoinRequest.find(params.fetch(:id))
    join_request.public_send("#{status}!")

    if status == "approved"
      TeamRosterManaging.add(
        join_request.joinable,
        join_request.requestor_type_name,
        join_request.requestor
      )
    end

    redirect_back fallback_location: student_team_path(current_team),
      success: t("controllers.student.join_requests.update.success",
                 name: join_request.requestor_first_name,
                 status: params.fetch(:status))
  end
end
