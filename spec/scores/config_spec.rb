require "spec_helper"
require "./app/scores/score_config"

RSpec.describe "Score config" do
  it "uses the score_fields YML file" do
    expect(ScoreConfig.filepath).to eq('./config/score_fields.yml')
  end

  it "returns config for a field" do
    allow(ScoreConfig).to receive(:loaded_config) { basic_config }

    expect(ScoreConfig.field(:field).label).to eq("Something good")
    expect(ScoreConfig.field(:field).values).to eq({ 0 => "Okay" })
  end

  def basic_config
    {
      "category" => {
        "weight" => 1,
        "field" => {
          "label" => "Something good",
          "values" => {
            0 => "Okay"
          }
        }
      }
    }
  end
end
