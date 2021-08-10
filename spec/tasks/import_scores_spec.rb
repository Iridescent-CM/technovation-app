require "rails_helper"

RSpec.describe "Tasks: rails import_scores" do
  it "imports QF scores from the given csv to ScoreSubmission" do
    judge = FactoryBot.create(
      :judge,
      account: FactoryBot.create(:account, email: "my@judge.com")
    )
    team = FactoryBot.create(:team, name: "world")
    submission = FactoryBot.create(:team_submission,
                                    app_name: "hello",
                                    team: team)

    headers = %w{team_submission_id ideation_1}
    rows = [%w{hello-world 4}]

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
    expect(score.ideation_1).to eq(4)
    expect(score.judge_profile).to eq(judge)
  end
end
