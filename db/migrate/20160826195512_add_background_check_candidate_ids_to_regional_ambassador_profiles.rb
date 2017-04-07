class AddBackgroundCheckCandidateIdsToRegionalAmbassadorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :regional_ambassador_profiles, :background_check_candidate_id, :string
    add_column :regional_ambassador_profiles, :background_check_report_id, :string
  end
end
