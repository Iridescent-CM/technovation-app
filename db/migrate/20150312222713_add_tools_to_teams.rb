class AddToolsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :tools, :string
  end
end
