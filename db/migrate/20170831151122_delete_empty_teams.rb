require "./lib/remove_empty_teams"

class DeleteEmptyTeams < ActiveRecord::Migration[5.1]
  def up
    RemoveEmptyTeams.call(Logger.new(STDOUT))
  end
end
