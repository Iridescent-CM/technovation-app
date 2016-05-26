require "spec_helper"

RSpec.describe "Score config" do
  class ScoreConfig
    def self.filepath
      './config/score_fields.yml'
    end
  end

  it "uses the score_fields YML file" do
    expect(ScoreConfig.filepath).to eq('./config/score_fields.yml')
  end
end
