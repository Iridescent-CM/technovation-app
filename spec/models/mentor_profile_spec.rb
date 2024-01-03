require "rails_helper"

RSpec.describe MentorProfile do
  describe ".searchable" do
    it "does not list mentors who have not completed training (and are required to)" do
      mentor = FactoryBot.create(:mentor, :onboarded)
      mentor.account.update(
        season_registered_at: ImportantDates.mentor_training_required_since
      )

      expect(mentor.reload).to be_searchable
      expect(MentorProfile.searchable).to include(mentor)

      mentor.update(training_completed_at: nil)

      expect(mentor.reload).not_to be_training_complete
      expect(mentor).to be_training_required
      expect(mentor).not_to be_searchable
      expect(MentorProfile.searchable).not_to include(mentor)
    end
  end

  describe ".unmatched" do
    it "lists mentors without a team" do
      FactoryBot.create(:mentor, :on_team)
      unmatched_mentor = FactoryBot.create(:mentor)
      expect(MentorProfile.unmatched).to eq([unmatched_mentor])
    end

    it "only considers current mentors" do
      past = FactoryBot.create(:mentor)
      past.account.update(seasons: [Season.current.year - 1])

      current_unmatched_mentor = FactoryBot.create(:mentor)

      expect(MentorProfile.unmatched).to eq([current_unmatched_mentor])
    end

    it "only considers current memberships" do
      current_unmatched_mentor = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        current_unmatched_mentor = FactoryBot.create(:mentor)

        current_unmatched_mentor.teams.create!({
          division: Division.for(current_unmatched_mentor),
          name: "Last year",
          seasons: [Season.current.year - 1]
        })
      end

      RegisterToCurrentSeasonJob.perform_now(current_unmatched_mentor.account)

      expect(MentorProfile.unmatched).to eq([current_unmatched_mentor])
    end

    it "avoids duplicate mentors who had past memberships" do
      mentor = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        mentor = FactoryBot.create(:mentor)

        mentor.teams.create!({
          division: Division.for(mentor),
          name: "Last year",
          seasons: [Season.current.year - 1]
        })
      end

      Timecop.freeze(Date.new(Season.current.year - 2, 10, 2)) do
        RegisterToCurrentSeasonJob.perform_now(mentor.account)

        mentor.teams.create!({
          division: Division.for(mentor),
          name: "Two years ago",
          seasons: [Season.current.year - 2]
        })
      end

      RegisterToCurrentSeasonJob.perform_now(mentor.account)

      expect(MentorProfile.unmatched).to eq([mentor])
    end
  end

  describe ".in_region" do
    it "scopes to the given US ambassador's state" do
      FactoryBot.create(:mentor, :los_angeles)
      il_mentor = FactoryBot.create(:mentor, :chicago)
      il_ambassador = FactoryBot.create(:ambassador, :chicago)

      expect(MentorProfile.in_region(il_ambassador)).to eq([il_mentor])
    end

    it "scopes to the given Int'l ambassador's country" do
      FactoryBot.create(:mentor, :chicago)
      intl_mentor = FactoryBot.create(:mentor, :brazil)
      intl_ambassador = FactoryBot.create(:ambassador, :brazil)

      expect(
        MentorProfile.in_region(intl_ambassador)
      ).to eq([intl_mentor])
    end
  end
end
