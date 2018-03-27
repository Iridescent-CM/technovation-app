class AddSeasonsToSubmissionScores < ActiveRecord::Migration[5.1]
  def up
    add_column :submission_scores,
      :seasons,
      :text,
      array: true,
      default: []

    SubmissionScore.update_all(seasons: [2017])
  end

  def down
    remove_column :submission_scores, :seasons
  end
end
