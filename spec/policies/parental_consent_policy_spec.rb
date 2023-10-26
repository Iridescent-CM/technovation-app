require "rails_helper"

describe ParentalConsentPolicy do
  subject { described_class }

  let(:parental_consent) { ParentalConsent.new(student_profile_id: 1) }

  permissions :show? do
    context "admins" do
      let(:admin) { FactoryBot.build(:admin) }

      it "allows access" do
        expect(subject).to permit(admin, parental_consent)
      end
    end

    context "guests" do
      let(:guest) { NullAuth.new }

      it "does not allow access" do
        expect(subject).not_to permit(guest, parental_consent)
      end
    end

    context "students" do
      let(:student) { FactoryBot.build(:student) }

      context "when the parental consent is their own" do
        let(:parental_consent) { FactoryBot.build(:parental_consent, student_profile: student) }

        it "allows access" do
          expect(subject).to permit(student, parental_consent)
        end
      end

      context "when the parental consent is someone else's" do
        let(:parental_consent) { FactoryBot.build(:parental_consent) }

        it "does not allow access" do
          expect(subject).not_to permit(student, parental_consent)
        end
      end
    end
  end
end
