class AddIssemifinalistToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :issemifinalist, :boolean
  end
end
