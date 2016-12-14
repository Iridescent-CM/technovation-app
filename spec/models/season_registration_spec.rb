require "rails_helper"

RSpec.describe SeasonRegistration do
  describe ".register" do
    it "rejects future seasons" do
      season = Season.create!(year: Season.current.year + 1)

      expect {
        SeasonRegistration.register(Object.new, season)
      }.to raise_error(SeasonRegistration::InvalidSeason)
    end
  end
end
