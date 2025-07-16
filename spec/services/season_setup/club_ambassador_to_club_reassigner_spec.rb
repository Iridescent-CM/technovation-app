require "rails_helper"

describe SeasonSetup::ClubAmbassadorToClubReassigner do
  let(:club_ambassador_to_club_reassigner) { SeasonSetup::ClubAmbassadorToClubReassigner.new }
  let(:club_ambassador_profile) { FactoryBot.create(:club_ambassador) }
  let(:account) { club_ambassador_profile.account }

  before do
    account.chapterable_assignments.delete_all
  end

  describe "#call" do
    context "when the club ambassador is assigned to a primary club for the previous season" do
      let(:last_season) { Season.current.year - 1 }
      let(:club) { FactoryBot.create(:club) }

      before do
        account.chapterable_assignments.create(
          profile: club_ambassador_profile,
          chapterable: club,
          season: last_season,
          primary: true
        )
      end

      context "when the club is active for the current season" do
        let(:current_season) { Season.current.year }

        before do
          club.update(seasons: [current_season])
        end

        it "reassigns the club ambassador to the club" do
          club_ambassador_to_club_reassigner.call

          expect(account.reload.current_chapterable_assignment.chapterable).to eq(club)
          expect(account.reload.current_chapterable_assignments.length).to eq(1)
        end
      end

      context "when the club is not active for the current season" do
        before do
          club.update(seasons: [last_season])
        end

        it "does not make a new chapterable assignment" do
          club_ambassador_to_club_reassigner.call

          expect(account.current_chapterable_assignments.length).to eq(0)
          expect(account.last_seasons_chapterable_assignments.length).to eq(1)
        end
      end
    end

    context "when the club ambassador is already assigned to a club for the current season" do
      let(:current_season) { Season.current.year }

      before do
        account.chapterable_assignments.create(
          profile: club_ambassador_profile,
          chapterable: FactoryBot.create(:club),
          season: current_season
        )
      end

      it "does not make a new chapterable assignment" do
        club_ambassador_to_club_reassigner.call

        expect(account.current_chapterable_assignments.length).to eq(1)
      end
    end
  end
end
