class AddParticipationToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :participation, :string
  end
end
