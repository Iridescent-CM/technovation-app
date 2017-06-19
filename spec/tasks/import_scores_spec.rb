require "rails_helper"

RSpec.describe "Tasks: rails import_scores" do
  it "imports QF scores from the given csv to ScoreSubmission" do
    judge = FactoryGirl.create(:judge, email: "my@judge.com")
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
    ENV["CSV_JUDGE_EMAIL"] = "my@judge.com"
    ENV["CSV_JUDGING_ROUND"] = "semifinals"
    ENV["CSV_LOGGING"] = "none"
    Rake::Task['import_scores'].invoke

    score = submission.submission_scores.semifinals.complete.first
    expect(score.sdg_alignment).to eq(4)
    expect(score.judge_profile).to eq(judge)
  end
end
