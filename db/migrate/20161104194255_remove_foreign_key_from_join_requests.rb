class RemoveForeignKeyFromJoinRequests < ActiveRecord::Migration
  def up
    remove_foreign_key :join_requests, column: :requestor_id
  end

  def down
    add_foreign_key :join_requests, :accounts, column: :requestor_id
  end
end
