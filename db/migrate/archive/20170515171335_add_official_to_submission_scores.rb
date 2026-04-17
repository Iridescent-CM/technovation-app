class AddOfficialToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :official, :boolean, default: true
  end
end
