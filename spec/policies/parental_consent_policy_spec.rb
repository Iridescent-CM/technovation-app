require "rails_helper"

describe ParentalConsentPolicy do
  subject { described_class }

  let(:parental_consent) { ParentalConsent.new(student_profile_id: 1) }

  permissions :show? do
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

    context "mentors" do
      let(:mentor) { FactoryBot.build(:mentor) }

      it "does not allow access" do
        expect(subject).not_to permit(mentor, parental_consent)
      end
    end

    context "judges" do
      let(:judge) { FactoryBot.build(:judge) }

      it "does not allow access" do
        expect(subject).not_to permit(judge, parental_consent)
      end
    end

    context "chapter ambassadors" do
      let(:chapter_ambassador) { FactoryBot.build(:chapter_ambassador) }

      it "does not allow access" do
        expect(subject).not_to permit(chapter_ambassador, parental_consent)
      end
    end

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
  end
end
