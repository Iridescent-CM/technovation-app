require "rails_helper"
require "./lib/migrate_legacy_seasons"

RSpec.describe MigrateLegacySeasons do
  before(:all) do
    @verbose = ActiveRecord::Migration.verbose
    ActiveRecord::Migration.verbose = false
  end

  after(:all) { ActiveRecord::Migration.verbose = @verbose }

  describe ".call" do
    it "converts Team seasons" do
      MigrateLegacySeasons::TestSetup.(:team)

      team = Team.last
      team.update(seasons: [])

      MigrateLegacySeasons.(:team)
      expect(team.reload.seasons).to eq([2015, 2016, 2017])
    end

    it "converts TeamSubmission seasons" do
      MigrateLegacySeasons::TestSetup.(:team_submission)

      submission = TeamSubmission.last
      submission.update(seasons: [])

      MigrateLegacySeasons.(:team_submission)
      expect(submission.reload.seasons).to eq([2015, 2016, 2017])
    end

    it "converts Account seasons" do
      MigrateLegacySeasons::TestSetup.(:account)

      account = Account.last
      account.update(seasons: [])

      MigrateLegacySeasons.(:account)
      expect(account.reload.seasons).to eq([2015, 2016, 2017])
    end
  end
end
