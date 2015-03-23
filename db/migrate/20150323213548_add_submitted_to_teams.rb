class AddSubmittedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :submitted, :boolean
  end
end
