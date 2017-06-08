require "spec_helper"
needs "technovation"
require "score_importing"

RSpec.describe ScoreImporting do
  def score_mock
    double(:ScoreMock)
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

  it "reads csv headers" do
    headers = %w{header1 header2}
    make_csv(headers: headers)

    importing = ScoreImporting.new(csv_path, score_mock)
    expect(importing.headers).to eq(headers)
  end

  it "reads csv rows" do
    rows = [%w{itemA itemB}, %w{itemC itemD}]
    make_csv(rows: rows)

    importing = ScoreImporting.new(csv_path, score_mock)
    expect(importing.rows).to eq(rows)
  end
end
