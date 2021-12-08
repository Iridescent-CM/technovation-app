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

    it "renders a filled/completed blue circle" do
      expect(rendered).to include("bg-energetic-blue")
    end
  end

  context "when the parental consent is unsigned" do
    let(:parental_consent) { FactoryBot.build(:parental_consent, :unsigned) }

    it "renders an empty circle (that isn't filled w/ blue)" do
      expect(rendered).to include("rounded-full")
      expect(rendered).not_to include("bg-energetic-blue")
    end
  end

  context "when the media consent is signed" do
    let(:media_consent) { FactoryBot.build(:media_consent, :signed) }

    it "renders a filled/completed blue circle" do
      expect(rendered).to include("bg-energetic-blue")
    end
  end

  context "when the media consent is unsigned" do
    let(:media_consent) { FactoryBot.build(:media_consent, :unsigned) }

    it "renders an empty circle (that isn't filled w/ blue)" do
      expect(rendered).to include("rounded-full")
      expect(rendered).not_to include("bg-energetic-blue")
    end
  end

  context "when the media consent doesn't exist" do
    let(:media_consent) { nil }

    it "renders an empty circle (that isn't filled w/ blue)" do
      expect(rendered).to include("rounded-full")
      expect(rendered).not_to include("bg-energetic-blue")
    end
  end
end
