require "will_paginate/array"

module Admin
  class ScoresController < AdminController
    def index
      params[:event] ||= "virtual"
      params[:round] ||= "quarterfinals"
      params[:page] ||= 1
      params[:per_page] ||= 15

      @division = params[:division] ||= "senior"

      sort = case params.fetch(:sort) { "avg_score_desc" }
             when "avg_score_desc"
               "team_submissions.average_score DESC"
             when "avg_score_asc"
               "team_submissions.average_score ASC"
             when "team_name"
               "teams.name ASC"
             end

      teams =
        if params[:round] == "quarterfinals"
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

          @event.teams
        else
          @events = RegionalPitchEvent.none
          Team.current.joins(:team_submissions)
              .where(team_submissions: { contest_rank: TeamSubmission.contest_ranks[:semifinalist]})
        end

      @teams = get_sorted_paginated_teams_in_requested_division(teams)
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
    def get_sorted_paginated_teams_in_requested_division(teams, page = params[:page])
      result = teams
        .includes(:regional_pitch_events, team_submissions: :submission_scores)
        .public_send(params[:division])
        .select { |t| t.selected_regional_pitch_event.live? or t.submission.complete? }
        .sort { |a, b|
          case params.fetch(:sort) { "avg_score_desc" }
          when "avg_score_desc"
            b.submission.average_score <=> a.submission.average_score
          when "avg_score_asc"
            a.submission.average_score <=> b.submission.average_score
          when "team_name"
            a.name <=> b.name
          end
        }.paginate(page: page.to_i, per_page: params[:per_page].to_i) unless teams.empty?

      if result.empty? and page.to_i != 1
        get_sorted_paginated_teams_in_requested_division(teams, 1)
      else
        result
      end
    end
  end
end
