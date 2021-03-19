class AddTrackingDetailsToSubmissionScores < ActiveRecord::Migration[5.2]
  def change
    add_column :submission_scores, :clicked_pitch_video, :boolean, null: false, default: false
    add_column :submission_scores, :clicked_demo_video, :boolean, null: false, default: false
    add_column :submission_scores, :downloaded_source_code, :boolean, null: false, default: false
    add_column :submission_scores, :downloaded_business_plan, :boolean, null: false, default: false
  end
end
