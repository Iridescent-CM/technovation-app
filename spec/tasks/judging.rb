require "rails_helper"

RSpec.describe "Tasks:" do
  describe "rails judging:check_semifinalists[path/to/file.csv]" do
    it "raises without expected headers" do
      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{not what it wants}
        csv << %w{1 2 3 4}
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/CSV FORMAT PROBLEM/)
    end

    it "raises without expected values" do
      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [1, nil]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*specifies a team_id and team_submission_id/)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [nil, 1]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*specifies a team_id and team_submission_id/)
    end

    it "raises if either model can't be found" do
      team = FactoryBot.create(:team, :submitted)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [0, team.submission.id]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*were not found.*Team with/m)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, 0]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*were not found.*TeamSubmission with/m)
    end

    it "raises unless team and submission match" do
      team = FactoryBot.create(:team, :submitted)
      other_submission = FactoryBot.create(:submission)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, other_submission.id]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*team and submission do not match/)
    end

    it "raises if other semifinalists exist in database" do
      team = FactoryBot.create(:team, :submitted)
      other = FactoryBot.create(:submission, :semifinalist)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, team.submission.id]
      end

      expect {
        Rake::Task['judging:check_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to raise_error(/DATA PROBLEM.*all semifinalists are included/)
    end
  end

  describe "rails judging:set_semifinalists[path/to/file.csv]" do
    it "sets specified team/submission to semifinalist" do
      team = FactoryBot.create(:team, :submitted)
      other = FactoryBot.create(:team, :submitted)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, team.submission.id]
      end

      expect {
        Rake::Task['judging:set_semifinalists'].execute(filename: "./tmp/test.csv")
      }.to change {
        TeamSubmission.current.semifinalist.count
      }.from(0).to(1)

      expect(team.reload.submission).to be_semifinalist
    end

    it "sets no semifinalists on error" do
      team = FactoryBot.create(:team, :submitted)
      other = FactoryBot.create(:submission, :semifinalist).team

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, team.submission.id]
      end

      expect {
        begin
          Rake::Task['judging:set_semifinalists'].execute(filename: "./tmp/test.csv")
        rescue
          # nothing
        end
      }.not_to change {
        TeamSubmission.current.semifinalist.count
      }

      expect(team.reload.submission).not_to be_semifinalist
    end
  end
end
