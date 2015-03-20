class AddTeamRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :team, index: true
  end
end
