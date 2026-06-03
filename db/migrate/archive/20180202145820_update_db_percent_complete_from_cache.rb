class UpdateDbPercentCompleteFromCache < ActiveRecord::Migration[5.1]
  def up
    TeamSubmission.all.find_each do |sub|
      sub.update_column(:percent_complete, sub.calculate_percent_complete)
    end
  end
end
