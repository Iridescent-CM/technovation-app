require "rails_helper"

RSpec.describe "assign_mentors_to_students_primary_chapterable" do
  let(:task) { Rake::Task["assign_mentors_to_students_primary_chapterable"] }
  let(:team) { FactoryBot.create(:team, :with_mentor) }

  after(:each) do
    task.reenable
  end

  context "when a team has a student without a primary chapterable assignment" do
    it "does not assign the mentor to a chapterable" do
      student = team.students.first
      student.account.current_chapterable_assignment.destroy
      mentor = team.mentors.first

      expect {
        task.invoke
      }.not_to change { mentor.account.chapterable_assignments.count }
    end
  end

  context "when a team has a student with a primary chapterable assignment" do
    it "assigns the mentor to the student's primary chapterable" do
      student = team.students.first
      mentor = team.mentors.first

      task.invoke
      expect(mentor.account.chapterable_assignments.map(&:chapterable)).to include(student.account.current_chapterable_assignment.chapterable)
    end
  end

  context "when a team has two students with different primary chapterable assignments" do
    it "assigns the mentor to all unique student primary chapterables" do
      student1 = team.students.first
      student2 = FactoryBot.create(:student)
      TeamRosterManaging.add(team, student2)

      mentor = team.mentors.first
      mentor.account.current_chapterable_assignment.destroy

      task.invoke

      expect(mentor.account.chapterable_assignments.map(&:chapterable)).to include(
        student1.account.current_chapterable_assignment.chapterable,
        student2.account.current_chapterable_assignment.chapterable
      )

      expect(mentor.account.chapterable_assignments.count).to eq(2)
    end
  end

  context "when a team has a student with a primary chapterable assignment and the mentor is already assigned to that chapterable" do
    it "does not create a duplicate assignment" do
      student = team.students.first
      mentor = team.mentors.first

      mentor.account.current_chapterable_assignment.destroy
      mentor.chapterable_assignments.create(
        chapterable: student.account.current_chapterable_assignment.chapterable,
        account: mentor.account,
        season: Season.current.year,
        primary: false
      )

      expect {
        task.invoke
      }.not_to change { mentor.account.chapterable_assignments.count }
    end
  end
end
