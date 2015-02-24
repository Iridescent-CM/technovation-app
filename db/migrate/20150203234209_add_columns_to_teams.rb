class AddColumnsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :description, :string
  end
end
