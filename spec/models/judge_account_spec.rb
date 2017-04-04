require "rails_helper"

RSpec.describe JudgeProfile do
  describe "#as_indexed_json" do
    it "doesn't explode on non-mentor judges" do
      judge = FactoryGirl.create(:judge)
      json = judge.as_indexed_json
      expect(json['mentor_profile_id']).to eql(nil)
      expect(json['region_division_names']).to eql(nil)
    end
  end
end
