require "rails_helper"

RSpec.describe "Tasks: rails fix_submissions" do
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    Rake::Task["fix_submissions"].reenable
    $stdout = STDOUT
  end

  it "marks onboarding students as onboarded" do
    students = FactoryBot.create_list(:student, 3, :onboarded)
    students.each do |student|
      student.update_column(:onboarded, false)
    end

    students.map!(&:reload)
    expect(students).to all(be_onboarding)

    Rake::Task["fix_submissions"].invoke

    students.map!(&:reload)
    expect(students).to all(be_onboarded)
  end

  it "selectively prints student info" do
    not_printed = FactoryBot.create(:student, :onboarded)
    printed = FactoryBot.create(:student, :onboarded)
    printed.update_column(:onboarded, false)

    Rake::Task["fix_submissions"].invoke

    expect(output.string).to include(printed.id.to_s)
    expect(output.string).to include(printed.email)
    expect(output.string).not_to include(not_printed.email)
  end

  it "marks team as having students where needed" do
    team = FactoryBot.create(:team)
    team.update_column(:has_students, false)

    team = team.reload
    expect(team.has_students).to be false
    expect(team).not_to be_qualified

    Rake::Task["fix_submissions"].invoke

    team = team.reload
    expect(team.has_students).to be true
    expect(team).to be_qualified
  end

  it "marks team as having all students onboarded where needed" do
    team = FactoryBot.create(:team)
    team.update_column(:all_students_onboarded, false)

    team = team.reload
    expect(team.all_students_onboarded).to be false
    expect(team).not_to be_qualified

    Rake::Task["fix_submissions"].invoke

    team = team.reload
    expect(team.all_students_onboarded).to be true
    expect(team).to be_qualified
  end

  it "selectively prints team info" do
    printed1 = FactoryBot.create(:team)
    printed1.update_column(:has_students, false)
    printed2 = FactoryBot.create(:team)
    printed2.update_column(:all_students_onboarded, false)
    not_printed = FactoryBot.create(:team)

    Rake::Task["fix_submissions"].invoke

    expect(output.string).to include(printed1.id.to_s)
    expect(output.string).to include(printed1.name)
    expect(output.string).to include(printed2.id.to_s)
    expect(output.string).to include(printed2.name)
    expect(output.string).not_to include(not_printed.name)
  end

  it "publishes submission ready for publishing" do
    submission = FactoryBot.create(:submission, :complete)
    submission.update_column(:published_at, nil)

    submission = submission.reload
    expect(submission).not_to be_published
    expect(submission).not_to be_complete
    expect(submission).to be_only_needs_to_submit

    Rake::Task["fix_submissions"].invoke

    submission = submission.reload
    expect(submission).to be_published
    expect(submission).to be_complete
  end

  it "prints info on submissions it publishes" do
    printed = FactoryBot.create(:submission, :complete)
    printed.update_column(:published_at, nil)
    not_printed = []
    not_printed << FactoryBot.create(:submission, :complete)
    not_printed << FactoryBot.create(:submission, :half_complete)

    Rake::Task["fix_submissions"].invoke

    expect(output.string).to include(printed.app_name)
    expect(output.string).to include(printed.team_name)
    expect(output.string).not_to include(*not_printed.map(&:team_name))
  end
end
