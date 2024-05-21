require "rails_helper"

RSpec.describe Chapter do
  let(:chapter) { FactoryBot.build(:chapter) }

  describe "delegations" do
    it "delegates #seasons_legal_agreement_is_valid_for to the legal contact" do
      expect(chapter.seasons_legal_agreement_is_valid_for)
        .to eq(chapter.legal_contact.seasons_legal_agreement_is_valid_for)
    end
  end
end
