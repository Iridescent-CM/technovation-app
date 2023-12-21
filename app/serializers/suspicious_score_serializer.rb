class SuspiciousScoreSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :raw_total, :total, :total_possible, :judge_name

  attribute :submission_name do |score|
    score.team_submission.app_name
  end

  attribute :team_name do |score|
    score.team_submission.team_name
  end

  attribute :team_division do |score|
    score.team_submission.team_division_name
  end

  attribute :event_name do |score|
    if score.semifinals?
      VirtualRegionalPitchEvent.new.name
    else
      score.team.event.name
    end
  end

  attribute :event_official do |score|
    if score.semifinals?
      "virtual"
    else
      score.team.event.official? ? "official" : "celebration"
    end
  end

  attribute :flags do |score|
    flags = []
    flags << "Seems too low" if score.seems_too_low?
    flags << "Completed too fast" if score.completed_too_fast_repeat_offense?
    flags.to_sentence
  end

  attribute :url do |score|
    Rails.application.routes.url_helpers.admin_score_path(score)
  end

  attribute :judge_url do |score|
    Rails.application.routes.url_helpers.admin_participant_path(score.judge_profile.account)
  end

  attribute :submission_url do |score|
    Rails.application.routes.url_helpers.admin_team_submission_path(score.team_submission)
  end
end
