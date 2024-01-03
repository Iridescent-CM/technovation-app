require "rails_helper"

RSpec.describe "drop_lowest_scores" do
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    $stdout = STDOUT
  end

  let(:task) { Rake::Task["drop_lowest_scores"] }
  after(:each) { task.reenable }

  let(:task_args) { [round, minimum_score_count, dry_run].map(&:to_s) }

  let!(:quarterfinalist_submission_1) {
    submission = FactoryBot.create(
      :submission,
      :complete,
      contest_rank: :quarterfinalist
    )
    FactoryBot.create_list(
      :score,
      3,
      :complete,
      team_submission: submission,
      round: :quarterfinals
    )
    submission
  }
  let!(:quarterfinalist_submission_2) {
    submission = FactoryBot.create(
      :submission,
      :complete,
      contest_rank: :quarterfinalist
    )
    FactoryBot.create_list(
      :score,
      3,
      :complete,
      team_submission: submission,
      round: :quarterfinals
    )
    submission
  }
  let!(:semifinalist_submission) {
    submission = FactoryBot.create(
      :submission,
      :complete,
      contest_rank: :semifinalist
    )
    FactoryBot.create_list(
      :score,
      3,
      :complete,
      team_submission: submission,
      round: :quarterfinals
    )
    FactoryBot.create_list(
      :score,
      3,
      :complete,
      team_submission: submission,
      round: :semifinals
    )
    submission
  }

  context "run for quarterfinals, count 1" do
    let(:round) { "qf" }
    let(:minimum_score_count) { 1 }

    context "dry run on" do
      let(:dry_run) { nil }
      before(:each) { task.invoke(*task_args) }

      it "reports dry run on" do
        expect(output.string).to include("DRY RUN: on")
      end

      it "reports quarterfinals submissions to drop a score for" do
        expect(output.string).to include("DROP Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("DROP Submission##{quarterfinalist_submission_2.id}")
      end

      it "omits semifinalist submission" do
        expect(output.string).not_to include("Submission##{semifinalist_submission.id}")
      end

      it "doesn't drop scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(3)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(3)
      end
    end

    context "dry run off" do
      let(:dry_run) { "run" }
      before(:each) { task.invoke(*task_args) }

      it "reports dry run off" do
        expect(output.string).to include("DRY RUN: off")
      end

      it "reports quarterfinals submissions to drop a score for" do
        expect(output.string).to include("DROP Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("DROP Submission##{quarterfinalist_submission_2.id}")
      end

      it "omits semifinalist submission" do
        expect(output.string).not_to include("Submission##{semifinalist_submission.id}")
      end

      it "drops scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(2)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(2)
      end
    end
  end

  context "run for quarterfinals, count 4" do
    let(:round) { "qf" }
    let(:minimum_score_count) { 4 }

    context "dry run on" do
      let(:dry_run) { nil }
      before(:each) { task.invoke(*task_args) }

      it "reports submissions skipped for not enough scores" do
        expect(output.string).to include("SKIP not enough scores for Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("SKIP not enough scores for Submission##{quarterfinalist_submission_2.id}")
      end

      it "doesn't drop scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(3)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(3)
      end
    end

    context "dry run off" do
      let(:dry_run) { "run" }
      before(:each) { task.invoke(*task_args) }

      it "reports submissions skipped for not enough scores" do
        expect(output.string).to include("SKIP not enough scores for Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("SKIP not enough scores for Submission##{quarterfinalist_submission_2.id}")
      end

      it "doesn't drop scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(3)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(3)
      end
    end
  end

  context "run a second time for quarterfinals, count 1" do
    let(:round) { "qf" }
    let(:minimum_score_count) { 1 }

    before(:each) {
      task.invoke(round, minimum_score_count, "run")
      task.reenable
      output.rewind

      task.invoke(*task_args)
    }

    context "dry run on" do
      let(:dry_run) { nil }

      it "reports submissions already dropped scores" do
        expect(output.string).to include("SKIP already dropped score for Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("SKIP already dropped score for Submission##{quarterfinalist_submission_2.id}")
      end

      it "doesn't drop more scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(2)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(2)
      end
    end

    context "dry run off" do
      let(:dry_run) { "run" }

      it "reports submissions already dropped scores" do
        expect(output.string).to include("SKIP already dropped score for Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).to include("SKIP already dropped score for Submission##{quarterfinalist_submission_2.id}")
      end

      it "doesn't drop more scores" do
        expect(quarterfinalist_submission_1.reload.scores.count).to eq(2)
        expect(quarterfinalist_submission_2.reload.scores.count).to eq(2)
      end
    end
  end

  context "run for semifinals, count 1" do
    let(:round) { "sf" }
    let(:minimum_score_count) { 1 }

    context "dry run on" do
      let(:dry_run) { nil }
      before(:each) { task.invoke(*task_args) }

      it "reports dry run on" do
        expect(output.string).to include("DRY RUN: on")
      end

      it "reports semifinals submission to drop a score for" do
        expect(output.string).to include("DROP Submission##{semifinalist_submission.id}")
      end

      it "omits quarterfinalist submissions" do
        expect(output.string).not_to include("Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).not_to include("Submission##{quarterfinalist_submission_2.id}")
      end

      it "doesn't drop any scores" do
        semifinalist_submission.reload
        expect(semifinalist_submission.quarterfinals_all_submission_scores.count).to eq(3)
        expect(semifinalist_submission.semifinals_all_submission_scores.count).to eq(3)
      end
    end

    context "dry run off" do
      let(:dry_run) { "run" }
      before(:each) { task.invoke(*task_args) }

      it "reports dry run on" do
        expect(output.string).to include("DRY RUN: off")
      end

      it "reports semifinals submission to drop a score for" do
        expect(output.string).to include("DROP Submission##{semifinalist_submission.id}")
      end

      it "omits quarterfinalist submissions" do
        expect(output.string).not_to include("Submission##{quarterfinalist_submission_1.id}")
        expect(output.string).not_to include("Submission##{quarterfinalist_submission_2.id}")
      end

      it "drops a semifinal score" do
        semifinalist_submission.reload
        expect(semifinalist_submission.quarterfinals_all_submission_scores.count).to eq(3)
        expect(semifinalist_submission.semifinals_all_submission_scores.count).to eq(2)
      end
    end
  end
end
