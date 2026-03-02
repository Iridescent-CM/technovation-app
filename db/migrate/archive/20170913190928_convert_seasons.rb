require "./lib/migrate_legacy_seasons"

class ConvertSeasons < ActiveRecord::Migration[5.1]
  def up
    MigrateLegacySeasons.call(:team, Logger.new($stdout))
    MigrateLegacySeasons.call(:team_submission, Logger.new($stdout))
    MigrateLegacySeasons.call(:account, Logger.new($stdout))
  end
end
