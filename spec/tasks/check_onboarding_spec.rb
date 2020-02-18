require "rails_helper"

RSpec.describe "Tasks: rails onboard_missed_students!" do
  it "marks onboarding students as onboarded where appropriate" do
    students = FactoryBot.create_list(:student, 3, :onboarded)
    students.each do |student|
      student.update_column(:onboarded, false)
    end

    students.map!(&:reload)
    expect(students).to all(be_onboarding)

    Rake::Task['onboard_missed_students!'].invoke

    students.map!(&:reload)
    expect(students).to all(be_onboarded)
  end
end
