class AddEventRefToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :event, index: true
  end
end
