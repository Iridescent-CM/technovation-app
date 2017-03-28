require "rails_helper"

RSpec.describe JudgeProfile do
  describe "#as_indexed_json" do
    it "doesn't explode on non-mentor judges" do
      judge = FactoryGirl.create(:judge)
      expect(judge.as_indexed_json).to eql({})
    end
  end
end
