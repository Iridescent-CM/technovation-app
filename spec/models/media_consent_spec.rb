require "rails_helper"

describe MediaConsent do
  context "validations" do
    let(:student_profile) { FactoryBot.create(:student) }

    context "#season" do
      context "when a season is provided" do
        let(:media_consent_params) { {season: Season.current.year} }

        it "successfully creates a new media consent" do
          expect {
            student_profile.media_consents.create(media_consent_params)
          }.to change { student_profile.media_consents.count }.by(1)
        end

        it "does not allow two media consent forms to exist for the same season" do
          expect {
            student_profile.media_consents.create(season: 2020)
            student_profile.media_consents.create(season: 2020)
          }.to raise_error(ActiveRecord::RecordNotUnique)
        end

        it "allows multiple media consent forms to exist for different seasons" do
          expect {
            student_profile.media_consents.create(season: 2020)
            student_profile.media_consents.create(season: 2021)
            student_profile.media_consents.create(season: 2022)
          }.to_not raise_error
        end
      end

      context "when a season is not provided" do
        let(:media_consent_params) { {season: nil} }

        it "does not create a new media consent" do
          expect {
            student_profile.media_consents.create(media_consent_params)
          }.to change { student_profile.media_consents.count }.by(0)
        end
      end
    end

    context "#electronic_signature and #consent_provided" do
      let(:media_consent) { student_profile.media_consents.create(season: Season.current.year) }

      context "when an electronic signature and consent are provided" do
        before do
          media_consent.electronic_signature = "Rita Pita"
          media_consent.consent_provided = true
        end

        it "is valid" do
          expect(media_consent).to be_valid
        end
      end

      context "when an electronic signature is not provided" do
        before do
          media_consent.electronic_signature = ""
          media_consent.consent_provided = true
        end

        it "is not valid" do
          expect(media_consent).not_to be_valid
          expect(media_consent.errors[:electronic_signature]).to include("can't be blank")
        end
      end

      context "when consent is not provided" do
        before do
          media_consent.consent_provided = ""
          media_consent.electronic_signature = "Kelly Yelly"
        end

        it "is not valid" do
          expect(media_consent).not_to be_valid
          expect(media_consent.errors[:consent_provided]).to include("is not included in the list")
        end
      end
    end
  end

  describe "#signed?" do
    context "when the media consent has an electronic signature" do
      let(:media_consent) { MediaConsent.new(electronic_signature: "Signereed It") }

      it "returns true" do
        expect(media_consent.signed?).to eq(true)
      end
    end

    context "when the media consent does not have an electronic signature" do
      let(:media_consent) { MediaConsent.new(electronic_signature: nil) }

      it "returns false" do
        expect(media_consent.signed?).to eq(false)
      end
    end
  end

  describe "#unsigned?" do
    context "when the media consent does not have an electronic signature" do
      let(:media_consent) { MediaConsent.new(electronic_signature: nil) }

      it "returns true" do
        expect(media_consent.unsigned?).to eq(true)
      end
    end

    context "when the media consent has an electronic signature" do
      let(:media_consent) { MediaConsent.new(electronic_signature: "Abe Lincoln") }

      it "returns false" do
        expect(media_consent.unsigned?).to eq(false)
      end
    end
  end

  describe "#uploaded?" do
    context "when the media consent has an `uploaded_at` date" do
      let(:media_consent) { MediaConsent.new(uploaded_at: 1.day.ago) }

      it "returns true" do
        expect(media_consent.uploaded?).to eq(true)
      end
    end

    context "when the media consent does not have an `uploaded_at` date" do
      let(:media_consent) { MediaConsent.new(uploaded_at: nil) }

      it "returns false" do
        expect(media_consent.uploaded?).to eq(false)
      end
    end
  end
end
