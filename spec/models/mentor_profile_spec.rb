require "rails_helper"

RSpec.describe MentorProfile do
  describe ".unmatched" do
    it "lists mentors without a team" do
      FactoryGirl.create(:mentor, :on_team)
      unmatched_mentor = FactoryGirl.create(:mentor)
      expect(MentorProfile.unmatched).to eq([unmatched_mentor])
    end

    it "only considers current mentors" do
      past = FactoryGirl.create(:mentor)
      past.account.update(seasons: [Season.current.year - 1])

      current_unmatched_mentor = FactoryGirl.create(:mentor)

      expect(MentorProfile.unmatched).to eq([current_unmatched_mentor])
    end

    it "only considers current memberships" do
      current_unmatched_mentor = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        current_unmatched_mentor = FactoryGirl.create(:mentor)

        current_unmatched_mentor.teams.create!({
          division: Division.for(current_unmatched_mentor),
          name: "Last year",
          seasons: [Season.current.year - 1],
        })
      end

      RegisterToCurrentSeasonJob.perform_now(current_unmatched_mentor.account)

      expect(MentorProfile.unmatched).to eq([current_unmatched_mentor])
    end

    it "avoids duplicate mentors who had past memberships" do
      mentor = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        mentor = FactoryGirl.create(:mentor)

        mentor.teams.create!({
          division: Division.for(mentor),
          name: "Last year",
          seasons: [Season.current.year - 1],
        })
      end

      Timecop.freeze(Date.new(Season.current.year - 2, 10, 2)) do
        RegisterToCurrentSeasonJob.perform_now(mentor.account)

        mentor.teams.create!({
          division: Division.for(mentor),
          name: "Two years ago",
          seasons: [Season.current.year - 2],
        })
      end

      RegisterToCurrentSeasonJob.perform_now(mentor.account)

      expect(MentorProfile.unmatched).to eq([mentor])
    end
  end

  describe ".in_region" do
    it "scopes to the given US ambassador's state" do
      FactoryGirl.create(
        :mentor,
        city: "Los Angeles",
        state_province: "CA",
        country: "US"
      )

      il_mentor = FactoryGirl.create(:mentor)
      il_ambassador = FactoryGirl.create(:ambassador)

      expect(
        MentorProfile.in_region(il_ambassador)
      ).to eq([il_mentor])
    end

    it "scopes to the given Int'l ambassador's country" do
      FactoryGirl.create(:mentor)

      intl_mentor = FactoryGirl.create(
        :mentor,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      intl_ambassador = FactoryGirl.create(
        :ambassador,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      expect(
        MentorProfile.in_region(intl_ambassador)
      ).to eq([intl_mentor])
    end
  end
end
