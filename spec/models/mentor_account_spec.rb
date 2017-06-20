require "rails_helper"

RSpec.describe MentorProfile do
  describe "#team_region_division_names" do
    it "should include all teams" do
      mentor = FactoryGirl.create(:mentor)
      t1 = FactoryGirl.create(:team,
                              city: "Los Angeles",
                              state_province: "CA",
                              division: Division.senior)
      TeamRosterManaging.add(t1, :mentor, mentor)

      t2 = FactoryGirl.create(:team, division: Division.junior)
      TeamRosterManaging.add(t2, :mentor, mentor)

      expect(mentor.team_region_division_names).to match_array([
        "US_CA,senior",
        "US_IL,junior"
      ])
    end

    it "should not contain duplicates" do
      mentor = FactoryGirl.create(:mentor)
      t1 = FactoryGirl.create(:team,
                              city: "Los Angeles",
                              state_province: "CA",
                              division: Division.senior)
      TeamRosterManaging.add(t1, :mentor, mentor)

      t2 = FactoryGirl.create(:team,
                              city: "Los Angeles",
                              state_province: "CA",
                              division: Division.senior)
      TeamRosterManaging.add(t2, :mentor, mentor)

      expect(mentor.team_region_division_names).to match_array(["US_CA,senior"])
    end
  end

  it "changes searchability when country changes" do
    mentor = FactoryGirl.create(:mentor) # Default in US

    # Sanity
    mentor.background_check.destroy
    expect(mentor).not_to be_searchable

    mentor.country = "BR"
    mentor.valid?
    expect(mentor).to be_searchable
  end
end
