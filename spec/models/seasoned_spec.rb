require "rails_helper"

RSpec.describe Seasoned do
  context "array-like seasons" do
    it "creates a current scope which matches Season.current.year" do
      account = FactoryBot.create(:account)
      expect(Account.current).to eq([account])
    end

    it "creates a past scope which matches any year before Season.current.year" do
      account = FactoryBot.create(:account, :past)
      expect(Account.past).to eq([account])
    end

    it "creates a scope by_season" do
      current = FactoryBot.create(:account)
      past = FactoryBot.create(:account, :past)

      expect(Account.by_season(Season.current.year)).to eq([current])
      expect(Account.by_season(past.seasons.sample)).to eq([past])
    end

    it "overrides rails' interpretation of PG array seasons field" do
      account = FactoryBot.create(:account)

      expect(account[:seasons]).to eq(["#{Season.current.year}"])
      expect(account.seasons).to eq([Season.current.year])
    end

    it "helps you know if the record is in the current season" do
      account = FactoryBot.create(:account)
      expect(account).to be_current_season

      account.seasons = [Season.current.year - 1]
      account.save!
      expect(account).not_to be_current_season
    end
  end

  context "integer seasons" do
    it "creates a current scope which matches Season.current.year" do
      cert = FactoryBot.create(:cert)
      expect(Certificate.current).to eq([cert])
    end

    it "creates a past scope which matches any year before Season.current.year" do
      cert = FactoryBot.create(:cert, :past)
      expect(Certificate.past).to eq([cert])
    end

    it "creates a scope by_season" do
      current = FactoryBot.create(:cert)
      past = FactoryBot.create(:cert, :past)

      expect(Certificate.by_season(Season.current.year)).to eq([current])
      expect(Certificate.by_season(past.season)).to eq([past])
    end

    it "provides a #seasons method to conform with array seasons" do
      cert = FactoryBot.create(:cert)

      expect(cert[:season]).to eq(Season.current.year)
      expect(cert.seasons).to eq([Season.current.year])
    end

    it "helps you know if the record is in the current season" do
      cert = FactoryBot.create(:cert)
      expect(cert).to be_current_season

      cert.season = Season.current.year - 1
      cert.save!
      expect(cert).not_to be_current_season
    end
  end
end
