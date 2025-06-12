require "rails_helper"

describe ClubSelector do
  let(:club_selector) { ClubSelector.new(account: account) }
  let(:account) { FactoryBot.create(:account, :mentor, :los_angeles) }

  describe "#call" do
    context "when there is a club in the same state/province" do
      let!(:los_angeles_club) { FactoryBot.create(:club, :los_angeles) }

      it "returns the club in the same state/province" do
        expect(club_selector.call).to eq({
          clubs_in_state_province: [los_angeles_club],
          clubs_in_country: []
        })
      end

      context "when there is a club in the same country" do
        let!(:chicago_club) { FactoryBot.create(:club, :chicago) }

        it "returns the club in the same state/province and the one in the country" do
          expect(club_selector.call).to eq({
            clubs_in_state_province: [los_angeles_club],
            clubs_in_country: [chicago_club]
          })
        end

        context "when the los angeles club isn't participating in the current season" do
          before do
            los_angeles_club.update(seasons: [])
          end

          it "does not include the los angeles club in the results" do
            expect(club_selector.call).to eq({
              clubs_in_state_province: [],
              clubs_in_country: [chicago_club]
            })
          end
        end

        context "when the account already belongs to the los angeles club" do
          before do
            account.chapterable_assignments.delete_all

            account.chapterable_assignments.create(
              chapterable: los_angeles_club,
              profile: account.mentor_profile,
              season: Season.current.year,
              primary: true
            )
          end

          it "does not include the los angeles club in the results" do
            expect(club_selector.call).to eq({
              clubs_in_state_province: [],
              clubs_in_country: [chicago_club]
            })
          end
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
