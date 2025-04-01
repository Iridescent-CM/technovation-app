require "rails_helper"

RSpec.describe MentorChapterableAssignmentsScrubber do
  let(:mentor_chapterable_assignments_scrubber) do
    MentorChapterableAssignmentsScrubber.new(mentor_profile: mentor_profile)
  end

  let(:mentor_profile) { FactoryBot.create(:mentor_profile) }
  let(:student_profile) { FactoryBot.create(:student) }
  let(:team) { FactoryBot.create(:team) }
  let(:chapter_mentor_should_be_removed_from) { FactoryBot.create(:chapter) }

  before do
    mentor_profile.chapterable_assignments.create(
      account: mentor_profile.account,
      chapterable: student_profile.current_chapterable,
      season: Season.current.year
    )

    TeamRosterManaging.add(team, mentor_profile)
    TeamRosterManaging.add(team, student_profile)
  end

  context "when the mentor has an invalid chapterable assignment" do
    before do
      mentor_profile.chapterable_assignments.create(
        account: mentor_profile.account,
        chapterable: chapter_mentor_should_be_removed_from,
        season: Season.current.year
      )
    end

    it "removes the invalid chapterable assignment for the mentor" do
      mentor_chapterable_assignments_scrubber.call

      mentor_chapterables = mentor_profile.reload.account.current_chapterable_assignments.map(&:chapterable)

      expect(mentor_chapterables).not_to include(chapter_mentor_should_be_removed_from)
    end

    it "does not remove the valid chapterable assignments for the mentor" do
      mentor_chapterable_assignments_scrubber.call

      mentor_chapterables = mentor_profile.reload.account.current_chapterable_assignments.map(&:chapterable)

      expect(mentor_chapterables).to include(student_profile.current_chapterable)
    end

    it "does not remove the primary chapterable assignment for the mentor" do
      mentor_chapterable_assignments_scrubber.call

      mentor_chapterables = mentor_profile.reload.account.current_chapterable_assignments.map(&:chapterable)

      expect(mentor_chapterables).to include(mentor_profile.account.current_chapterable)
    end
  end
end
