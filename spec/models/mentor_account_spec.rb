require "rails_helper"

RSpec.describe MentorProfile do
  describe "#team_region_division_names" do
    it "should include all teams" do
      mentor = FactoryBot.create(:mentor, :onboarded)
      t1 = FactoryBot.create(:team,
                              city: "Los Angeles",
                              state_province: "CA")

      student = t1.students.first

      ProfileUpdating.execute(student, account_attributes: {
        id: student.account_id,
        date_of_birth: 15.years.ago,
      })

      TeamRosterManaging.add(t1, mentor)

      t2 = FactoryBot.create(:team)
      TeamRosterManaging.add(t2, mentor)

      expect(mentor.team_region_division_names).to match_array([
        "US_CA,senior",
        "US_IL,junior"
      ])
    end

    it "should not contain duplicates" do
      mentor = FactoryBot.create(:mentor, :onboarded)
      t1 = FactoryBot.create(:team,
                              city: "Los Angeles",
                              state_province: "CA")
      TeamRosterManaging.add(t1, mentor)

      t2 = FactoryBot.create(:team,
                              city: "Los Angeles",
                              state_province: "CA")
      TeamRosterManaging.add(t2, mentor)

      [t1, t2].each do |team|
        student = team.students.first

        ProfileUpdating.execute(student, account_attributes: {
          id: student.account_id,
          date_of_birth: 15.years.ago,
        })
      end

      expect(mentor.team_region_division_names).to match_array(["US_CA,senior"])
    end
  end

  it "changes searchability when country changes" do
    mentor = FactoryBot.create(:mentor, :onboarded) # Default in US

    # Sanity
    mentor.background_check.destroy
    expect(mentor).not_to be_searchable

    mentor.city = "Salvador"
    mentor.state_province = "BA"
    mentor.country = "BR"
    mentor.valid?
    expect(mentor).to be_searchable
  end
end
