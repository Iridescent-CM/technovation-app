require "rails_helper"

RSpec.describe SeasonSetup::ChapterAffiliationAgreementDeactivator do
  let(:chapter_affiliation_agreement_deactivator) { SeasonSetup::ChapterAffiliationAgreementDeactivator.new }
  let(:legal_contact) { FactoryBot.create(:legal_contact) }

  describe "#call" do
    context "when an affiliation agreement expired last season" do
      before do
        legal_contact.chapter_affiliation_agreement.update(season_expires: Season.current.year - 1)
      end

      it "marks the affiliation agreement as inactive" do
        chapter_affiliation_agreement_deactivator.call

        expect(legal_contact.chapter_affiliation_agreement.reload.active).to eq(false)
      end
    end

    context "when an affiliation agreement is still active" do
      before do
        legal_contact.chapter_affiliation_agreement.update(season_expires: Season.current.year + 1)
      end

      it "keeps the affiliation agreement active" do
        chapter_affiliation_agreement_deactivator.call

        expect(legal_contact.chapter_affiliation_agreement.reload.active).to eq(true)
      end
    end
  end
end
