require "rails_helper"

RSpec.describe "Tasks: judging namespace" do
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    $stdout = STDOUT
  end

  context "rails judging:set_contest_rank" do
    let(:task) { Rake::Task["judging:set_contest_rank"] }
    after(:each) { task.reenable }

    it "sets the specified current submissions to specified rank" do
      sub1 = FactoryBot.create(:submission, :complete)
      sub2 = FactoryBot.create(:submission, :complete)
      sub3 = FactoryBot.create(:submission, :complete)

      task.invoke(:semifinalist, sub1.id, sub2.id)

      expect(sub1.reload).to be_semifinalist
      expect(sub2.reload).to be_semifinalist
      expect(sub3.reload).to be_quarterfinalist
    end

    it "does not update past submissions" do
      past = FactoryBot.create(:submission)
      past.update(seasons: [Season.current.year - 1])

      task.invoke(:semifinalist, past.id)

      expect(past.reload).not_to be_semifinalist
    end

    it "raises error for bad rank" do
      sub = FactoryBot.create(:submission)

      expect {
        task.invoke(:notathing, sub.id)
      }.to raise_error ArgumentError, /not a valid contest_rank/
    end
  end
end
