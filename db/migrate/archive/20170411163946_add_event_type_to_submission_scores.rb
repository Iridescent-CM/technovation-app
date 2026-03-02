class AddEventTypeToSubmissionScores < ActiveRecord::Migration[4.2]
  def change
    add_column :submission_scores, :event_type, :string
  end
end
