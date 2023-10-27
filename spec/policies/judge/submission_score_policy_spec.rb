require "rails_helper"

describe Judge::SubmissionScorePolicy do
  subject { described_class }

  let(:score) { FactoryBot.create(:score) }

  permissions :new? do
    context "students" do
      let(:student) { FactoryBot.build(:student) }

      it "does not allow access" do
        expect(subject).not_to permit(student, score)
      end
    end

    context "mentors" do
      let(:student) { FactoryBot.build(:mentor) }

      it "does not allow access" do
        expect(subject).not_to permit(student, score)
      end
    end

    context "judges" do
      let(:judge) { FactoryBot.create(:judge) }

      context "when the score is their own" do
        let(:score) { FactoryBot.create(:score, judge_profile: judge) }

        it "allows access" do
          expect(subject).to permit(judge, score)
        end
      end

      context "when the score is someone else's" do
        let(:score) { FactoryBot.create(:score, judge_profile: FactoryBot.create(:judge)) }

        it "does not allow access" do
          expect(subject).not_to permit(judge, score)
        end
      end
    end

    context "chapter ambassadors" do
      let(:student) { FactoryBot.build(:chapter_ambassador) }

      it "does not allow access" do
        expect(subject).not_to permit(student, score)
      end
    end

    context "admins" do
      let(:admin) { FactoryBot.build(:admin) }

      it "does not allow access" do
        expect(subject).not_to permit(admin, score)
      end
    end

    context "guests" do
      let(:guest) { NullAuth.new }

      it "does not allow access" do
        expect(subject).not_to permit(guest, score)
      end
    end
  end
end
