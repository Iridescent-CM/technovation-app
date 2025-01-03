class AddOnboardedToClubAmbassadors < ActiveRecord::Migration[6.1]
  def change
    add_column :club_ambassador_profiles, :onboarded, :boolean, default: false
  end
end
