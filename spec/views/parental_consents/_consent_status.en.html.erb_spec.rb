require "rails_helper"

RSpec.describe "parental_consents/_consent_status.en.html.erb", type: :view do
  before do
    render partial: "parental_consents/consent_status",
      locals: {
        parental_consent: parental_consent,
        media_consent: media_consent
      }
  end

  let(:parental_consent) { FactoryBot.build(:parental_consent) }
  let(:media_consent) { FactoryBot.build(:media_consent) }

  context "when the parental consent is signed" do
    let(:parental_consent) { FactoryBot.build(:parental_consent, :signed) }

    it "renders a circle with a checkmark" do
      expect(rendered).to include("check-circle")
    end
  end

  context "when the parental consent is unsigned" do
    let(:parental_consent) { FactoryBot.build(:parental_consent, :unsigned) }

    it "renders a circle without a checkmark" do
      expect(rendered).to include("circle-o")
      expect(rendered).not_to include("check-circle")
    end
  end

  context "when the media consent is signed" do
    let(:media_consent) { FactoryBot.build(:media_consent, :signed) }

    it "renders a circle with a checkmark" do
      expect(rendered).to include("check-circle")
    end
  end

  context "when the media consent is unsigned" do
    let(:media_consent) { FactoryBot.build(:media_consent, :unsigned) }

    it "renders a circle without a checkmark" do
      expect(rendered).to include("circle-o")
      expect(rendered).not_to include("check-circle")
    end
  end

  context "when the media consent doesn't exist" do
    let(:media_consent) { nil }

    it "renders a circle without a checkmark" do
      expect(rendered).to include("circle-o")
      expect(rendered).not_to include("check-circle")
    end
  end
end
