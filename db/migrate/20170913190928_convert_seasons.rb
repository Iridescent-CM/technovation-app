require "./lib/migrate_legacy_seasons"

class ConvertSeasons < ActiveRecord::Migration[5.1]
  def up
    MigrateLegacySeasons.(:team, Logger.new($stdout))
    MigrateLegacySeasons.(:team_submission, Logger.new($stdout))
    MigrateLegacySeasons.(:account, Logger.new($stdout))
  end
end
