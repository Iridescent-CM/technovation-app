class RenameDemoVideoColumnOnSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    rename_column :submission_scores, :demo_video, :demo
  end
end
