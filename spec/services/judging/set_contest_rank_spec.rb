require "rails_helper"

RSpec.describe Judging::SetContestRank do
  describe "#call" do
    it "sets the specified current submissions to the specified rank" do
      sub1 = FactoryBot.create(:submission, :complete)
      sub2 = FactoryBot.create(:submission, :complete)
      sub3 = FactoryBot.create(:submission, :complete)

      described_class.new(
        rank: :semifinalist,
        submission_ids: [sub1.id, sub2.id]
      ).call

      expect(sub1.reload).to be_semifinalist
      expect(sub2.reload).to be_semifinalist
      expect(sub3.reload).to be_quarterfinalist
    end

    it "does not update past submissions" do
      past = FactoryBot.create(:submission)
      past.update(seasons: [Season.current.year - 1])

      described_class.new(
        rank: :semifinalist,
        submission_ids: [past.id]
      ).call

      expect(past.reload).not_to be_semifinalist
    end
  end
end
