class RenameIswinnerOnTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :iswinner, :is_winner
  end
end
