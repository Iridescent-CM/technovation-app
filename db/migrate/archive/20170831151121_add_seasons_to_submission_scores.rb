class AddSeasonsToSubmissionScores < ActiveRecord::Migration[5.1]
  def up
    unless column_exists?(:submission_scores, :seasons)
      add_column :submission_scores,
        :seasons,
        :text,
        array: true,
        default: []

      SubmissionScore.update_all(seasons: [2017])
    end
  end

  def down
    if column_exists?(:submission_scores, :seasons)
      remove_column :submission_scores, :seasons
    end
  end
end
