class AddPlatformToTeams < ActiveRecord::Migration
  def change
    change_table(:teams) do |t|    
      # managed bitwise field
      t.integer :platform, :null => false, :default => 0
	end
  end
end
