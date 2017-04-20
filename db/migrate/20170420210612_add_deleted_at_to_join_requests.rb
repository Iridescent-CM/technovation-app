class AddDeletedAtToJoinRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :join_requests, :deleted_at, :datetime
  end
end
