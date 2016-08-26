class AddBackgroundCheckCandidateIdsToMentorProfiles < ActiveRecord::Migration
  def change
    add_column :mentor_profiles, :background_check_candidate_id, :string
    add_column :mentor_profiles, :background_check_report_id, :string
  end
end
