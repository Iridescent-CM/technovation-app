require "will_paginate/array"

module Admin
  class ScoresController < AdminController
    def index
      params[:event] ||= "virtual"
      params[:page] ||= 1
      params[:per_page] ||= 15

      @division = params[:division] ||= "senior"

      @sort = case params.fetch(:sort) { "avg_score_desc" }
              when "avg_score_desc"
                "team_submissions.quarterfinals_average_score DESC"
              when "avg_score_asc"
                "team_submissions.quarterfinals_average_score ASC"
              when "team_name"
                "lower(teams.name) ASC"
              end

      events = RegionalPitchEvent.eager_load(regional_ambassador_profile: :account).all
      virtual_event = Team::VirtualRegionalPitchEvent.new

      @event = if params[:event] == "virtual"
                 virtual_event
               else
                 events.eager_load(
                   :divisions,
                   :judges,
                   teams: { team_submissions: :submission_scores }
                 ).find(params[:event])
               end

      @events = [virtual_event] + events.sort_by { |e|
        FriendlyCountry.(e.regional_ambassador_profile.account)
      }

      @submissions = get_sorted_paginated_submissions_in_requested_division
    end

    def show
      @team_submission = TeamSubmission.includes(
        team: :division,
        submission_scores: { judge_profile: :account }
      ).friendly.find(params[:id])

      @team = @team_submission.team

      @event = @team.selected_regional_pitch_event

      @scores = @team_submission.submission_scores
        .complete
        .quarterfinals
        .includes(judge_profile: :account)
        .references(:accounts)
        .order("accounts.first_name")

      render "regional_ambassador/scores/show"
    end

    private
    def get_sorted_paginated_submissions_in_requested_division(page = params[:page])
      submissions = @event.team_submissions
        .public_send(params[:division])
        .includes(:submission_scores, team: :regional_pitch_events)
        .where("team_submissions.complete = ? OR regional_pitch_events_teams.regional_pitch_event_id IS NOT NULL", true)
        .order(@sort)
        .paginate(page: page.to_i, per_page: params[:per_page].to_i)

      if submissions.empty? and page.to_i != 1
        get_sorted_paginated_submissions_in_requested_division(1)
      else
        submissions
      end
    end
  end
end
