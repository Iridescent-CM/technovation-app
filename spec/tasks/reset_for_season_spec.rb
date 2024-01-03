require "rails_helper"

RSpec.describe "Resetting for season" do
  let(:rollover_date) { Time.new(Time.now.year, Season::START_MONTH, Season::START_DAY) }
  let(:other_date) { rollover_date - 1.month }
  let(:task) { Rake::Task["reset_for_season"] }
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    task.reenable
    $stdout = STDOUT
  end

  context "on season rollover day" do
    before(:each) { Timecop.freeze(rollover_date) }
    after(:each) { Timecop.return }

    it "runs without being forced" do
      task.invoke

      expect(output.string).to include("Resetting consent waivers")
      expect(output.string).to include("Resetting data use terms")
      expect(output.string).to include("Resetting onboarded flags")
      expect(output.string).to include("Resetting mentor trainings")
      expect(output.string).to include("Resetting judge trainings")
      expect(output.string).to include("Finished resetting")
    end
  end

  context "on other days" do
    before(:each) { Timecop.freeze(other_date) }
    after(:each) { Timecop.return }

    it "runs if forced" do
      task.invoke("force")

      expect(output.string).to include("Resetting consent waivers")
      expect(output.string).to include("Resetting data use terms")
      expect(output.string).to include("Resetting onboarded flags")
      expect(output.string).to include("Resetting mentor trainings")
      expect(output.string).to include("Resetting judge trainings")
      expect(output.string).to include("Finished resetting")
    end

    it "doesn't run if not forced" do
      task.invoke

      expect(output.string).to include("The reset needs to happen on the season start date")
    end
  end
end
