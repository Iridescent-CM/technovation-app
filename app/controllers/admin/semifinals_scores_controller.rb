require "will_paginate/array"

module Admin
  class SemifinalsScoresController < AdminController
    def index
      params[:page] ||= 1
      params[:per_page] ||= 15

      @sort = case params.fetch(:sort) { "avg_score_desc" }
             when "avg_score_desc"
               "team_submissions.semifinals_average_score DESC"
             when "avg_score_asc"
               "team_submissions.semifinals_average_score ASC"
             when "team_name"
               "lower(teams.name) ASC"
             end
      @division = params[:division] ||= "senior"

      @submissions = get_sorted_paginated_submissions_in_requested_division
    end

    def show
      @team_submission = TeamSubmission.includes(
        team: :division,
        submission_scores: { judge_profile: :account }
      ).friendly.find(params[:id])

      @team = @team_submission.team

      @scores = @team_submission.submission_scores
        .complete
        .semifinals
        .includes(judge_profile: :account)
        .references(:accounts)
        .order("accounts.first_name")
    end

    private
    def get_sorted_paginated_submissions_in_requested_division(page = params[:page])
      submissions = TeamSubmission.semifinalist
        .public_send(params[:division])
        .includes(:submission_scores)
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