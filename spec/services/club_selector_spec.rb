require "rails_helper"

describe ClubSelector do
  let(:club_selector) { ClubSelector.new(account: account) }
  let(:account) { FactoryBot.create(:account, :los_angeles) }

  describe "#call" do
    context "when there is a club in the same state/province" do
      let(:las_angeles_club) { FactoryBot.create(:club, :los_angeles) }

      it "returns the club in the same state/province" do
        expect(club_selector.call).to eq({
          clubs_in_state_province: [las_angeles_club],
          clubs_in_country: []
        })
      end

      context "when there is a club in the same country" do
        let(:chicago_club) { FactoryBot.create(:club, :chicago) }

        it "returns the club in the same state/province and the one in the country" do
          expect(club_selector.call).to eq({
            clubs_in_state_province: [las_angeles_club],
            clubs_in_country: [chicago_club]
          })
        end
      end
    end

    context "when there are no clubs in the same state/province or country" do
      before do
        Club.delete_all
      end

      it "returns an empty result" do
        expect(club_selector.call).to eq({
          clubs_in_state_province: [],
          clubs_in_country: []
        })
      end
    end
  end
end
