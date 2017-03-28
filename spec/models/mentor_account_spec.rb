require "rails_helper"

RSpec.describe MentorProfile do
  describe "#team_region_division_names" do
    it "should include all teams" do
      mentor = FactoryGirl.create(:mentor)
      t1 = FactoryGirl.create(:team, creator_in: "Los Angeles", division: Division.senior)
      t1.add_mentor(mentor)
      t2 = FactoryGirl.create(:team, creator_in: "Chicago", division: Division.junior)
      t2.add_mentor(mentor)

      expect(mentor.team_region_division_names).to match_array(["US_CA,senior", "US_IL,junior"])
    end
  end
end