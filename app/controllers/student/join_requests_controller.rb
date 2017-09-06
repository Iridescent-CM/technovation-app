class Student::JoinRequestsController < StudentController
  def new
    @team = Team.find(params.fetch(:team_id))
  end

  def create
    team = Team.find(params.fetch(:team_id))

    current_student.join_requests.find_or_create_by!(team: team)

    redirect_to student_dashboard_path,
      success: t("controllers.student.join_requests.create.success", name: team.name)
  end

  def update
    status = params.fetch(:status)

    join_request = JoinRequest.find(params.fetch(:id))
    "join_request_#{status}".camelize.constantize.(join_request)

    redirect_back fallback_location: student_team_path(
      current_team,
      anchor: join_request.requestor_scope_name.pluralize
    ),
      anchor: join_request.requestor_scope_name.pluralize,
      success: t("controllers.student.join_requests.update.success",
                 name: join_request.requestor_first_name,
                 status: params.fetch(:status))
  end
end
