class DropRequestsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :requests
  end
end
