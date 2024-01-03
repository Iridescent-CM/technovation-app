require "rails_helper"

RSpec.describe "check_onboarding tasks" do
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    task.reenable
    $stdout = STDOUT
  end

  context "rails onboard_missed_students!" do
    let(:task) { Rake::Task["onboard_missed_students!"] }

    it "marks onboarding students as onboarded where appropriate" do
      students = FactoryBot.create_list(:student, 3, :onboarded)
      students.each do |student|
        student.update_column(:onboarded, false)
      end

      students.map!(&:reload)
      expect(students).to all(be_onboarding)

      task.invoke

      students.map!(&:reload)
      expect(students).to all(be_onboarded)
    end
  end

  context "rails fix_student_onboarding!" do
    let(:task) { Rake::Task["fix_student_onboarding!"] }

    it "marks onboarding students as onboarded if appropriate" do
      students = FactoryBot.create_list(:student, 3, :onboarded)
      students.each do |student|
        student.update_column(:onboarded, false)
      end

      students.map!(&:reload)
      expect(students).to all(be_onboarding)

      task.invoke

      students.map!(&:reload)
      expect(students).to all(be_onboarded)
    end

    it "marks onboarded students as onboarding if appropriate" do
      students = FactoryBot.create_list(:student, 3, :onboarding)
      students.each do |student|
        student.update_column(:onboarded, true)
      end

      students.map!(&:reload)
      expect(students).to all(be_onboarded)

      task.invoke

      students.map!(&:reload)
      expect(students).to all(be_onboarding)
    end
  end
end
