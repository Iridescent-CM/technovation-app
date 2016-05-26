require 'spec_helper'
require './app/scores/score'

RSpec.describe "total possible score" do
  subject(:total_possible) { Score.total_possible }

  it "returns 0 for a config of 0 values" do
    allow(Score).to receive(:config) { all_zeros_config }
    expect(total_possible).to eq(0)
  end

  it "returns a sum of all 1 values" do
    allow(Score).to receive(:config) { all_ones_config }
    expect(total_possible).to eq(1)
  end

  it "returns the sum of the maximum values" do
    allow(Score).to receive(:config) { mixed_values_config }
    expect(total_possible).to eq(8)
  end

  def all_zeros_config
    {
      "category_name" => {
        "field_name" => { "values" => { "0" => 'Value explanation'  } }
      }
    }
  end

  def all_ones_config
    {
      "category_name" => {
        "field_name" => { "values" => { "1" => 'Value explanation'  } }
      }
    }
  end

  def mixed_values_config
    {
      "category_name" => {
        "field_name" => {
          "values" => {
            "1" => 'Value explanation',
            "4" => "Value explained"
          }
        },

        "field_name_2" => {
          "values" => {
            "1" => 'Value explanation',
            "2" => "Value explained"
          }
        }
      },

      "category_name_2" => {
        "field_name" => {
          "values" => {
            "1" => 'Value explanation',
            "2" => "Value explained"
          }
        }
      }
    }
  end
end
