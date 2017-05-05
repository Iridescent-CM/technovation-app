require "will_paginate/array"

module Admin
  class ScoresController < AdminController
    def index
      params[:event] ||= "virtual"
      params[:round] ||= "quarterfinals"
      params[:page] ||= 1
      params[:per_page] ||= 15

      @division = params[:division] ||= "senior"

      send("get_#{params[:round]}_events_and_submissions")
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
        .includes(judge_profile: :account)
        .references(:accounts)
        .order("accounts.first_name")

      render "regional_ambassador/scores/show"
    end

    private
    def get_quarterfinals_events_and_submissions
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

      @submissions = get_sorted_paginated_submissions_in_requested_division(@event.team_submissions)
    end

    def get_semifinals_events_and_submissions
      @events = RegionalPitchEvent.none
      @submissions = get_sorted_paginated_submissions_in_requested_division(TeamSubmission.current.semifinalist)
    end

    def get_sorted_paginated_submissions_in_requested_division(submissions, page = params[:page])
      result = submissions
        .includes(:submission_scores)
        .public_send(params[:division])
        .select { |s| s.team.selected_regional_pitch_event.live? or s.complete? }
        .sort { |a, b|
          case params.fetch(:sort) { "avg_score_desc" }
          when "avg_score_desc"
            b.average_score <=> a.average_score
          when "avg_score_asc"
            a.average_score <=> b.average_score
          when "team_name"
            a.team.name <=> b.team.name
          end
        }.paginate(page: page.to_i, per_page: params[:per_page].to_i) unless submissions.empty?

      if result.empty? and page.to_i != 1
        get_sorted_paginated_submissions_in_requested_division(submissions, 1)
      else
        result
      end
    end
  end
end
