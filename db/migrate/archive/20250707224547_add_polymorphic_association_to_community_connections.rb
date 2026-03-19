class AddPolymorphicAssociationToCommunityConnections < ActiveRecord::Migration[6.1]
  def change
    add_column :community_connections, :ambassador_type, :string
    add_column :community_connections, :ambassador_id, :integer

    add_index :community_connections, [:ambassador_type, :ambassador_id], name: "index_community_connections_on_ambassador"
  end
end
