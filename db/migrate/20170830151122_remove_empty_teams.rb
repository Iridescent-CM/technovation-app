require './lib/remove_empty_teams'

class RemoveEmptyTeams < ActiveRecord::Migration[5.1]
  def up
    RemoveEmptyTeams.execute
  end
end
