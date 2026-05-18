module AdminScoresSubmissionScope
  COMPLETE_OFFICIAL_SCORES_LIMIT = 3

  module_function

  def call(scope, round:)
    return scope if round.to_s == "semifinals"

    scope.virtual.where(
      "complete_#{round}_official_submission_scores_count IS NULL OR " \
      "complete_#{round}_official_submission_scores_count < ?",
      COMPLETE_OFFICIAL_SCORES_LIMIT
    )
  end

  def resolve_round(params)
    grid = params[:scored_submissions_grid] || params["scored_submissions_grid"] || {}
    passed_round = grid[:round] || grid["round"]

    return passed_round if passed_round.present?

    current_round = SeasonToggles.current_judging_round(full_name: true).to_s

    if ["semifinals", "finished"].include?(current_round)
      "semifinals"
    else
      "quarterfinals"
    end
  end
end
