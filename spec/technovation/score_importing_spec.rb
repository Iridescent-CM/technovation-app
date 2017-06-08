require "spec_helper"
require "logger"
needs "technovation"
require "score_importing"

RSpec.describe ScoreImporting do
  it "saves csv data to the score repository" do
    score_mock = class_spy("SubmissionScore")
    sub_mock = class_spy("TeamSubmission")
    sub_instance = instance_spy("team_submission", id: 1)
    sub_instance2 = instance_spy("team_submission", id: 2)

    headers = %w{team_submission_id attr_a attr_b}
    rows = [%w{friendly-id-1 value_a value_b},
            %w{friendly-id-2 value_a2 value_b2}]

    make_csv(headers: headers, rows: rows)

    expect(sub_mock).to receive(:from_param)
      .with("friendly-id-1")
      .and_return(sub_instance)

    expect(sub_mock).to receive(:from_param)
      .with("friendly-id-2")
      .and_return(sub_instance2)

    expect(score_mock).to receive(:from_csv).with({
      "judge_profile_id" => 1836,
      "team_submission_id" => 1,
      "attr_a" => 'value_a',
      "attr_b" => 'value_b',
    })

    expect(score_mock).to receive(:from_csv).with({
      "judge_profile_id" => 1836,
      "team_submission_id" => 2,
      "attr_a" => 'value_a2',
      "attr_b" => 'value_b2',
    })

    importing = ScoreImporting.new(
      csv_path,
      score_mock,
      sub_mock,
      Logger.new('/dev/null')
    )

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
