class AddBgCheckIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :bg_check_id, :string
  end
end
