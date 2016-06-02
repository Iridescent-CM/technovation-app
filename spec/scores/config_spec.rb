require "spec_helper"
require "./app/scores/score_config"

RSpec.describe "Score config" do
  it "uses the score_fields YML file" do
    expect(ScoreConfig.filepath).to eq('./config/score_fields.yml')
  end

  before do
    allow(ScoreConfig).to receive(:loaded_config) { basic_config }
  end

  let(:field) { ScoreConfig.field(:field) }

  it "returns a field's label" do
    expect(field.label).to eq("Something good")
  end

  it "returns a field's values" do
    expect(field.values).to eq({ 0 => "Okay" })
  end

  it "returns a field's value explanation" do
    expect(field.explanation(0)).to eq("Okay")
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
