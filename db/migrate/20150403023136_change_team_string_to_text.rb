class ChangeTeamStringToText < ActiveRecord::Migration
  def change
	change_column :teams, :description, :text
	change_column :teams, :tools, :text
	change_column :teams, :challenge, :text
	change_column :teams, :participation, :text
  end
end
