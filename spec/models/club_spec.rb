require "rails_helper"

RSpec.describe Club do
  let(:club) do
    FactoryBot.create(:club,
      name: club_name,
      summary: club_summary,
      headquarters_location: club_headquarters_location,
      primary_contact: club_ambassador.account,
      onboarded: false)
  end

  let(:club_name) { "LA Tech Club" }
  let(:club_summary) { "A tech club in LA" }
  let(:club_headquarters_location) { "Los Angeles, CA" }
  let(:club_ambassador) { FactoryBot.create(:club_ambassador) }

  context "callbacks" do
    context "#after_update" do
      describe "updating the onboarded status" do
        context "when all onboarding steps have been completed" do
          before do
            club.program_information.destroy
            club.reload
            FactoryBot.create(:program_information, chapterable: club)

            club.update(
              name: "My club",
              summary: "My club's summary",
              headquarters_location: "My club's HQ location",
              primary_contact: club_ambassador.account
            )
          end

          it "returns true" do
            expect(club.reload.onboarded?).to eq(true)
          end
        end

        context "when trying to set a club's name to nil" do
          before do
            result = club.update(name: nil)
            expect(result).to eq(false)
          end

          it "does not update due to validation error" do
            expect(club.onboarded?).to eq(true)
          end
        end

        context "when the club's summary is missing" do
          before do
            club.update(summary: nil)
          end

          it "returns false" do
            expect(club.onboarded?).to eq(false)
          end
        end

        context "when the club doesn't have a primary contact" do
          before do
            club.update(primary_contact: nil)
          end

          it "returns false" do
            expect(club.onboarded?).to eq(false)
          end
        end

        context "when the club's HQ location is missing" do
          before do
            club.update(headquarters_location: nil)
          end

          it "returns false" do
            expect(club.onboarded?).to eq(false)
          end
        end
      end
    end
  end

  describe "#location_complete?" do
    context "When the club's HQ location is present" do
      let(:club_headquarters_location) { "San Francisco, CA" }

      it "returns true" do
        expect(club.location_complete?).to eq(true)
      end
    end

    context "When the club's HQ location is blank" do
      let(:club_headquarters_location) { nil }

      it "returns false" do
        expect(club.location_complete?).to eq(false)
      end
    end
  end

  describe "#club_info_complete?" do
    context "When all of the clubs public info has been completed" do
      let(:club_name) { "SF Coding Club" }
      let(:club_summary) { "Super aweseome coding club in SF" }
      let(:club_ambassador) { FactoryBot.create(:club_ambassador) }

      it "returns true" do
        expect(club.club_info_complete?).to eq(true)
      end
    end

    context "When the club's summary is blank" do
      let(:club_summary) { nil }

      it "returns false" do
        expect(club.club_info_complete?).to eq(false)
      end
    end

    context "When the club doesn't have a primary contact" do
      before do
        club.primary_contact = nil
      end

      it "returns false" do
        expect(club.club_info_complete?).to eq(false)
      end
    end
  end

  describe "#program_info_complete?" do
    context "When all of the club's program info has been completed" do
      it "returns true" do
        expect(club.program_info_complete?).to eq(true)
      end
    end

    context "When the club doesn't have program info" do
      before do
        club.program_information.destroy
      end

      it "returns false" do
        expect(club.reload.program_info_complete?).to eq(false)
      end
    end
  end
end
