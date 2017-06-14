require "spec_helper"
require "logger"
needs "technovation"
require "score_importing"

RSpec.describe ScoreImporting do
  it "saves csv data to the score repository" do
    score_mock = class_spy("SubmissionScore")
    sub_mock = class_spy("TeamSubmission")

    score_instance = instance_spy("score_instance")
    score_instance2 = instance_spy("score_instance")

    sub_instance = instance_spy("team_submission", id: 1)
    sub_instance2 = instance_spy("team_submission", id: 2)

    headers = %w{team_submission_id attr_a attr_b}
    rows = [%W{friendly-id-1 1 2},
            %W{friendly-id-2 3 4}]

    make_csv(headers: headers, rows: rows)

    expect(sub_mock).to receive(:from_param)
      .with("friendly-id-1")
      .and_return(sub_instance)

    expect(sub_mock).to receive(:from_param)
      .with("friendly-id-2")
      .and_return(sub_instance2)

    expect(score_mock).to receive(:judging_round)
      .twice
      .with("semifinals")
      .and_return(0)

    expect(score_mock).to receive(:from_csv).with({
      "judge_profile_id" => 9,
      "attr_a" => 1,
      "attr_b" => 2,
      "team_submission_id" => 1,
      "round" => 0,
    }).and_return(score_instance)

    expect(score_mock).to receive(:from_csv).with({
      "judge_profile_id" => 9,
      "attr_a" => 3,
      "attr_b" => 4,
      "team_submission_id" => 2,
      "round" => 0,
    }).and_return(score_instance2)

    expect(score_instance).to receive(:complete!)
    expect(score_instance2).to receive(:complete!)

    importing = ScoreImporting.new({
      csv_path: csv_path,
      judge_id: 9,
      judging_round: "semifinals",
      scores: score_mock,
      submissions: sub_mock,
    })

    importing.import_scores
  end

  def csv_path
    "./tmp/test.csv"
  end

  def make_csv(options = {})
    default_options = {
      headers: %w{h1 h2},
      rows: [%w{i1 i2}, %w{i3 i4}],
    }

    used_options = default_options.merge(options)

    CSV.open(csv_path, "wb") do |csv|
      csv << used_options[:headers]
      used_options[:rows].each { |r| csv << r }
    end
  end
end
