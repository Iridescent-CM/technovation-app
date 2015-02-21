class AddBgCheckIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :bg_check_id, :string
    add_column :users, :bg_check_submitted, :datetime
  end
end
