class Mentor::JoinRequestsController < MentorController
  def new
    @team = Team.find(params.fetch(:team_id))
  end

  def create
    @team = Team.find(params.fetch(:team_id))
    join_request = JoinRequest.new(requestor: current_mentor,
                                   joinable: @team)
    if join_request.save
      redirect_to [:mentor, join_request],
                  success: t("controllers.mentor.join_requests.create.success",
                             name: @team.name)
    else
      render :new
    end
  end

  def show
    @join_request = current_mentor.join_requests.find(params.fetch(:id))
  end

  def update
    join_request = JoinRequest.find(params.fetch(:id))
    "join_request_#{status}".camelize.constantize.(join_request)

    redirect_back fallback_location: mentor_dashboard_path,
      success: t("controllers.mentor.join_requests.update.success",
                 name: join_request.requestor_first_name,
                 status: params.fetch(:status))
  end
end
