class RenameIssemifinalistOnTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :issemifinalist, :is_semi_finalist
  end
end
