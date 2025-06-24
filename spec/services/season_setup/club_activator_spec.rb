require "rails_helper"

RSpec.describe SeasonSetup::ClubActivator do
  let(:club_activator) { SeasonSetup::ClubActivator.new }
  let!(:club) { FactoryBot.create(:club) }

  before do
    club.update(seasons: [])
  end

  describe "#call" do
    context "when a club was active during the previous season" do
      before do
        club.update(seasons: [Season.current.year - 1])
      end

      it "assigns the club to the current season" do
        club_activator.call

        expect(club.reload.seasons).to include(Season.current.year)
      end

      context "when a club already belongs to the current season" do
        before do
          club.update(seasons: club.seasons + [Season.current.year])
        end

        it "does not reassign the club to the current season" do
          club_activator.call

          expect(club.reload.seasons).to eq([
            Season.current.year - 1,
            Season.current.year
          ])
        end
      end
    end

    context "when a club was not active during the previous season" do
      before do
        club.update(seasons: [Season.current.year - 5])
      end

      it "does not assign the club to the current season" do
        club_activator.call

        expect(club.reload.seasons).not_to include(Season.current.year)
      end
    end
  end
end
