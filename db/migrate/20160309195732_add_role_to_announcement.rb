class AddRoleToAnnouncement < ActiveRecord::Migration
  def change
    add_column :announcements, :role, :integer, default: 0, null: false
  end
end
