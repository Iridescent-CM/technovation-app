class BustSubmissionProgressCache < ActiveRecord::Migration[5.1]
  def up
    TeamSubmission.current.find_each do |sub|
      cache_key = "#{sub.cache_key}/percent_complete"
      Rails.cache.delete(cache_key)
      sub.update_column(:percent_complete, sub.calculate_percent_complete)
    end
  end
end
