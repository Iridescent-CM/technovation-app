require "rails_helper"

RSpec.describe Judging::SetContestRankFromCsv do
  describe "#call" do
    let(:sub1) { FactoryBot.create(:submission, :complete) }
    let(:sub2) { FactoryBot.create(:submission, :complete) }

    def csv_file(contents)
      file = Tempfile.new(["semifinalists", ".csv"])
      file.write(contents)
      file.rewind
      file
    end

    it "updates submissions from a semicolon-separated CSV" do
      file = csv_file("Team ID;Submission ID;Team name\n;#{sub1.id};Team A\n;#{sub2.id};Team B\n")

      result = described_class.new(csv_file: file, rank: :semifinalist).call

      expect(result.updated_count).to eq(2)
      expect(sub1.reload).to be_semifinalist
      expect(sub2.reload).to be_semifinalist
    ensure
      file.close
      file.unlink
    end

    it "updates submissions from a comma-separated CSV" do
      file = csv_file("Submission ID\n#{sub1.id}\n#{sub2.id}\n")

      result = described_class.new(csv_file: file, rank: :semifinalist).call

      expect(result.updated_count).to eq(2)
      expect(sub1.reload).to be_semifinalist
      expect(sub2.reload).to be_semifinalist
    ensure
      file.close
      file.unlink
    end

    it "raises when the submission id column is missing" do
      file = csv_file("Team ID\n123\n")

      expect {
        described_class.new(csv_file: file, rank: :semifinalist).call
      }.to raise_error(described_class::MissingSubmissionIdColumn)
    ensure
      file.close
      file.unlink
    end
  end
end
