module Mentor
  class JoinRequestsController < MentorController
    before_action :require_onboarded

    def new
      @team = Team.find(params.fetch(:team_id))

      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_team_path(@team),
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      end
    end

    def create
      @team = Team.find(params.fetch(:team_id))

      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_team_path(@team),
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      elsif
        if join_request = current_mentor.join_requests.find_by(team: @team)
          join_request.pending!
        else
          join_request = current_mentor.join_requests.create!(team: @team)
        end

        redirect_to mentor_join_request_path(join_request),
          success: t("controllers.mentor.join_requests.create.success",
                    name: @team.name)
      end
    end

    def show
      @join_request = JoinRequest.find_by(
        review_token: params.fetch(:id)
      ) || ::NullJoinRequest.new

      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_team_path(
          @join_request.team,
          anchor: @join_request.requestor_scope_name.pluralize
        ),
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      elsif reviewer_is_requestor?(@join_request)
        render template: "join_requests/show_requestor_#{@join_request.status}"
      elsif reviewer_is_unauthorized?(@join_request)
        redirect_to mentor_dashboard_path,
          alert: "You do not have permission to visit that page"
      else
        render template: "join_requests/show_#{@join_request.status}"
      end
    end

    def update
      status = join_request_params.fetch(:status)

      join_request = JoinRequest.find_by(review_token: params.fetch(:id)) ||
        ::NullJoinRequest.new

      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_team_path(
          join_request.team,
          anchor: join_request.requestor_scope_name.pluralize
        ),
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      elsif
        "join_request_#{status}".camelize.constantize.(join_request)

        redirect_to params[:back] || mentor_team_path(
          join_request.team,
          anchor: join_request.requestor_scope_name.pluralize
        ),
        success: t("controllers.mentor.join_requests.update.success",
                  name: join_request.requestor_first_name,
                  status: status)
      end
    end

    def destroy
      join_request = JoinRequest.find_by(review_token: params.fetch(:id))
      join_request.deleted!

      redirect_to mentor_dashboard_path(anchor: "/find-team"),
        success: t(
          "controllers.mentor.join_requests.destroy.success",
          name: join_request.team_name
        )
    end

    private
    def reviewer_is_requestor?(join_request)
      current_mentor.authenticated? and current_mentor == join_request.requestor
    end

    def reviewer_is_unauthorized?(join_request)
      current_mentor.authenticated? and
        not current_mentor.is_on?(join_request.team)
    end

    def join_request_params
      params.require(:join_request).permit(:status)
    end
  end
end
