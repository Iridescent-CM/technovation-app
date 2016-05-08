class RenameIsfinalistOnTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :isfinalist, :is_finalist
  end
end
