class RemoveBackgroundCheckFields < ActiveRecord::Migration
  def change
    remove_column :mentor_profiles, :background_check_candidate_id, :string
    remove_column :mentor_profiles, :background_check_report_id, :string
    remove_column :mentor_profiles, :background_check_completed_at, :datetime

    remove_column :regional_ambassador_profiles, :background_check_candidate_id, :string
    remove_column :regional_ambassador_profiles, :background_check_report_id, :string
    remove_column :regional_ambassador_profiles, :background_check_completed_at, :datetime
  end
end
