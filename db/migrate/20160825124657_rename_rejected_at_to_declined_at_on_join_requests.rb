class RenameRejectedAtToDeclinedAtOnJoinRequests < ActiveRecord::Migration[4.2]
  def change
    rename_column :join_requests, :rejected_at, :declined_at
  end
end
