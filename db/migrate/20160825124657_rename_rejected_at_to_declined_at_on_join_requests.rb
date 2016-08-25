class RenameRejectedAtToDeclinedAtOnJoinRequests < ActiveRecord::Migration
  def change
    rename_column :join_requests, :rejected_at, :declined_at
  end
end
