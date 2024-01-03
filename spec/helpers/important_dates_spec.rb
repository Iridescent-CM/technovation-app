require "rails_helper"

RSpec.describe ImportantDates do
  describe ".rpe_officiality_finalized" do
    it "is 11:59 pm of the configured date" do
      expect(ImportantDates.rpe_officiality_finalized.hour).to eq(23)
      expect(ImportantDates.rpe_officiality_finalized.min).to eq(59)
    end

    it "is the application configured time zone regardless of user time zone" do
      [
        "Alaska",
        "London",
        "Tokyo"
      ].each do |zone|
        Time.use_zone(zone) do
          expect(ImportantDates.rpe_officiality_finalized.time_zone.name).to eq(Rails.configuration.time_zone)
        end
      end
    end
  end
end
