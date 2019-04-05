require "rails_helper"

RSpec.describe "SetSemifinalists" do
  describe "dry run" do
    it "raises without expected headers" do
      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{not what it wants}
        csv << %w{1 2 3 4}
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/CSV FORMAT PROBLEM/)
      ssf.dry_run
    end

    it "raises without expected values" do
      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [1, nil]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*specifies a team_id and team_submission_id/)
      ssf.dry_run

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [nil, 1]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*specifies a team_id and team_submission_id/)
      ssf.dry_run
    end

    it "raises if either model can't be found" do
      team = FactoryBot.create(:team, :submitted)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [0, team.submission.id]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*were not found.*Team with/m)
      ssf.dry_run

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, 0]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*were not found.*TeamSubmission with/m)
      ssf.dry_run
    end

    it "raises unless team and submission match" do
      team = FactoryBot.create(:team, :submitted)
      other_submission = FactoryBot.create(:submission)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, other_submission.id]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*team and submission do not match/)
      ssf.dry_run
    end

    it "raises if other semifinalists exist in database" do
      team = FactoryBot.create(:team, :submitted)
      other = FactoryBot.create(:submission, :semifinalist)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, team.submission.id]
      end

      ssf = SetSemifinalists.read('./tmp/test.csv')
      expect(ssf.logger).to receive(:error).with(/Team.*not in csv/)
      expect(ssf.logger).to receive(:error).with(/DATA PROBLEM.*all semifinalists are included/)
      ssf.dry_run
    end
  end

  describe "perform!" do
    it "sets specified team/submission to semifinalist" do
      team = FactoryBot.create(:team, :submitted)
      other = FactoryBot.create(:team, :submitted)

      CSV.open("./tmp/test.csv", "wb") do |csv|
        csv << %w{team_id team_submission_id}
        csv << [team.id, team.submission.id]
      end

      expect {
        SetSemifinalists.read('./tmp/test.csv').perform!
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
          SetSemifinalists.read('./tmp/test.csv').perform!
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
