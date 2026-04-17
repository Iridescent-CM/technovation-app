class RemoveChapterAmbassadorProfileIdFromCommunityConnections < ActiveRecord::Migration[6.1]
  def change
    remove_column :community_connections, :chapter_ambassador_profile_id
  end
end
