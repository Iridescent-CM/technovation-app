class AddViewedCommunityConnectionsToClubAmbassadors < ActiveRecord::Migration[6.1]
  def change
    add_column :club_ambassador_profiles, :viewed_community_connections, :boolean, null: false, default: false
  end
end
