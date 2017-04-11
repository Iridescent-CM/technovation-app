class AddEventTypeToSubmissionScores < ActiveRecord::Migration
  def change
    add_column :submission_scores, :event_type, :string
  end
end
