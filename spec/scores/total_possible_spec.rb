require 'spec_helper'
require './app/models/score'

RSpec.describe "total possible score" do
  subject(:total_possible) { Score.total_possible }

  it "returns 0 for a config of 0 values" do
    allow(Score).to receive(:config) { all_zeros_config }
    expect(total_possible).to eq(0)
  end

  it "returns a sum of all 1 values"
  it "returns the sum of the maximum values"

  def all_zeros_config
    {
      "category_name" => {
        "field_name" => { "values" => { "0" => 'Value explanation'  } }
      }
    }
  end
end
