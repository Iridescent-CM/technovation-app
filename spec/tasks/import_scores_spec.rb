require "rails_helper"
require 'rake'
Rails.application.load_tasks

RSpec.describe "Tasks: rails import_scores" do
  it "imports QF scores from the given csv to ScoreSubmission" do
    FactoryGirl.create(:judge, id: 1836)
    team = FactoryGirl.create(:team, name: "world")
    submission = FactoryGirl.create(:team_submission,
                                    app_name: "hello",
                                    team: team)

    headers = %w{team_submission_id sdg_alignment}
    rows = [%w{hello-by-world 4}]

    CSV.open("./tmp/test.csv", "wb") do |csv|
      csv << headers
      rows.each { |r| csv << r }
    end

    ENV["CSV_SOURCE"] = "./tmp/test.csv"
    Rake::Task['import_scores'].invoke

    expect(submission.submission_scores.first.sdg_alignment).to eq(4)
  end
end
