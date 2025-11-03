class AddProjectDetails2ToSubmissionScores < ActiveRecord::Migration[7.0]
  def change
    add_column :submission_scores, :project_details_2, :integer, default: 0
  end
end
