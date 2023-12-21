require "rails_helper"
require "./lib/migrate_legacy_seasons"

RSpec.describe MigrateLegacySeasons do
  before do
    @verbose = ActiveRecord::Migration.verbose
    ActiveRecord::Migration.verbose = false
  end

  after { ActiveRecord::Migration.verbose = @verbose }

  describe ".call" do
    it "converts Team seasons" do
      MigrateLegacySeasons::TestSetup.call(:team)

      team = Team.last
      team.update(seasons: [])

      MigrateLegacySeasons.call(:team)
      expect(team.reload.seasons).to eq([2015, 2016, 2017])
    end

    it "converts TeamSubmission seasons" do
      MigrateLegacySeasons::TestSetup.call(:team_submission, :junior)

      submission = TeamSubmission.last
      submission.update(seasons: [])

      MigrateLegacySeasons.call(:team_submission)
      expect(submission.reload.seasons).to eq([2015, 2016, 2017])
    end

    it "converts Account seasons" do
      MigrateLegacySeasons::TestSetup.call(:account)

      account = Account.last
      account.update(seasons: [])

      MigrateLegacySeasons.call(:account)
      expect(account.reload.seasons).to eq([2015, 2016, 2017])
    end
  end
end
