require './lib/remove_empty_teams'

class DeleteEmptyTeams < ActiveRecord::Migration[5.1]
  def up
    RemoveEmptyTeams.(Logger.new(STDOUT))
  end
end
