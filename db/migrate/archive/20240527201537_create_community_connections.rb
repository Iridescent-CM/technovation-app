class CreateCommunityConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :community_connections do |t|
      t.text :topic_sharing_response
      t.references :chapter_ambassador_profile, foreign_key: true

      t.timestamps
    end
  end
end
