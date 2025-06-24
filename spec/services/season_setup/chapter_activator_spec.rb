require "rails_helper"

RSpec.describe SeasonSetup::ChapterActivator do
  let(:chapter_activator) { SeasonSetup::ChapterActivator.new }
  let!(:chapter) { FactoryBot.create(:chapter) }

  before do
    chapter.update(seasons: [])
  end

  describe "#call" do
    context "when a chapter was active during the previous season" do
      before do
        chapter.update(seasons: [Season.current.year - 1])
      end

      context "when a chapter has a valid chapter affiliation agreement" do
        before do
          Document.create(
            full_name: chapter.legal_contact.full_name,
            email_address: chapter.legal_contact.email_address,
            signer: chapter.legal_contact,
            season_signed: Season.current.year,
            signed_at: Time.now
          )
        end

        it "assigns the chapter to the current season" do
          chapter_activator.call

          expect(chapter.reload.seasons).to include(Season.current.year)
        end
      end

      context "when a chapter does not have a valid chapter affiliation agreement" do
        before do
          chapter.legal_contact.chapter_affiliation_agreement.delete
        end

        it "does not assign the chapter to the current season" do
          chapter_activator.call

          expect(chapter.reload.seasons).not_to include(Season.current.year)
        end
      end

      context "when a chapter already belongs to the current season" do
        before do
          chapter.update(seasons: chapter.seasons + [Season.current.year])
        end

        it "does not reassign the chapter to the current season" do
          chapter_activator.call

          expect(chapter.reload.seasons).to eq([
            Season.current.year - 1,
            Season.current.year
          ])
        end
      end
    end

    context "when a chapter was not active during the previous season" do
      before do
        chapter.update(seasons: [Season.current.year - 5])
      end

      it "does not assign the chapter to the current season" do
        chapter_activator.call

        expect(chapter.reload.seasons).not_to include(Season.current.year)
      end
    end
  end
end
