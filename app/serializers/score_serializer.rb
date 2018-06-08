class ScoreSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :total, :total_possible

  attribute :submission_name do |score|
    score.team_submission.app_name
  end

  attribute :team_name do |score|
    score.team_submission.team_name
  end

  attribute :team_division do |score|
    score.team_submission.team_division_name
  end

  attribute :url do |score|
    Rails.application.routes.url_helpers.new_judge_score_path(score_id: score.id)
  end

  attribute :submission_url do |score|
    Rails.application.routes.url_helpers.app_path(score.team_submission)
  end

  # attribute :ideation do |score|
  #   {
  #     sdg_alignment: score.sdg_alignment,
  #     todo: "TODO: add more stuff!"
  #     comment: {
  #       text: "Add more properties!"
  #     }
  #   }
  # end

  # attribute :technical do |score|
  #   {
  #     todo: "TODO: add more stuff!"
  #     comment: {
  #       text: "Add more properties!"
  #     }
  #   }
  # end

  # attribute :entrepreneurship do |score|
  #   if score.team_submission.junior?
  #     {}
  #   else
  #     {
  #       todo: "TODO: add more stuff!"
  #       comment: {
  #         text: "Add more properties!"
  #       }
  #     }
  #   end
  # end
end
