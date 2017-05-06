require "will_paginate/array"

module Legacy
  module V2
    module Admin
      class ScoresController < AdminController
        def index
          params[:event] ||= "virtual"
          params[:page] ||= 1
          params[:per_page] ||= 15

          @division = params[:division] ||= "senior"

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
            .includes(:submission_scores, team: :regional_pitch_events)
            .public_send(params[:division])
            .select { |s| s.team.selected_regional_pitch_event.live? or s.complete? }
            .sort { |a, b|
              case params.fetch(:sort) { "avg_score_desc" }
              when "avg_score_desc"
                b.quarterfinals_average_score <=> a.quarterfinals_average_score
              when "avg_score_asc"
                a.quarterfinals_average_score <=> b.quarterfinals_average_score
              when "team_name"
                a.team.name <=> b.team.name
              end
            }

          if submissions.empty? and page.to_i != 1
            get_sorted_paginated_submissions_in_requested_division(1)
          else
            submissions
          end
        end
      end
    end
  end
end
