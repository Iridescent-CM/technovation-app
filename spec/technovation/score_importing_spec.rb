require "spec_helper"
needs "technovation"
require "score_importing"

RSpec.describe ScoreImporting do
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

  it "saves csv data to the score repository" do
    score_mock = class_spy("ScoreMock")
    headers = %w{attr_a attr_b}
    rows = [%w{value_a value_b}, %w{value_a2 value_b2}]
    make_csv(headers: headers, rows: rows)

    expect(score_mock).to receive(:from_csv).with({
      "attr_a" => 'value_a',
      "attr_b" => 'value_b',
    })

    expect(score_mock).to receive(:from_csv).with({
      "attr_a" => 'value_a2',
      "attr_b" => 'value_b2',
    })

    importing = ScoreImporting.new(csv_path, score_mock)
    importing.import_scores
  end
end
