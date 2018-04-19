class DetectSuspiciousScores < ActiveRecord::Migration[5.1]
  def up
    SubmissionScore.current.find_each(&:save)
  end
end
