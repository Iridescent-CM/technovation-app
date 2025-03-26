require "rails_helper"

RSpec.describe MentorToTeamChapterableAssigner do
  let(:mentor_to_team_chapterable_assigner) do
    MentorToTeamChapterableAssigner.new(mentor_profile: mentor_profile,
      team: team)
  end

  let(:mentor_profile) { FactoryBot.create(:mentor_profile) }
  let(:team) { FactoryBot.create(:team) }
  let(:student1) { FactoryBot.create(:student) }

  before do
    TeamRosterManaging.add(team, student1)
  end

  context "when the mentor is not assigned to the team's student's chaperables" do
    before do
      mentor_profile.account.chapterable_assignments.delete_all
    end

    it "assigns the mentor to the team's student's chapterables" do
      mentor_to_team_chapterable_assigner.call

      mentor_chapterables = mentor_profile.reload.account.current_chapterable_assignments.map(&:chapterable)

      expect(mentor_chapterables).to include(team.students.first.account.current_chapterable_assignment.chapterable)
      expect(mentor_chapterables).to include(team.students.second.account.current_chapterable_assignment.chapterable)
    end
  end

  context "when the mentor is already assigned to the team's student's chaperables" do
    before do
      team.students.each do |student|
        mentor_profile.account.chapterable_assignments.create(
          profile: mentor_profile,
          chapterable: student.current_chapterable_assignment.chapterable,
          season: Season.current.year,
          primary: true
        )
      end
    end

    it "does not create duplicate assignments; it contains unique chapterable assignments (3 total, 1 for the mentor and 2 for the student's on the team)" do
      mentor_to_team_chapterable_assigner.call

      unique_mentor_chapterables = mentor_profile.reload.account.current_chapterable_assignments.map(&:chapterable).uniq

      expect(unique_mentor_chapterables.count).to eq(3)
    end
  end
end
