require 'spec_helper'
require './app/scores/score'

RSpec.describe "list fields by category" do
  subject(:fields) { ScoreConfig.fields(:category_name) }

  it "is empty when the category does not exist" do
    allow(ScoreConfig).to receive(:loaded_config) { {} }
    expect(fields).to be_empty
  end

  it "is empty when the category does not have any fields" do
    allow(ScoreConfig).to receive(:loaded_config) { { "category_name" => {} } }
    expect(fields).to be_empty
  end

  it "lists all category fields" do
    allow(ScoreConfig).to receive(:loaded_config) { category_has_fields_config }
    expect(fields).to eq(["field_name"])
  end

  def category_has_fields_config
    {
      "category_name" => {
        "field_name" => { "values" => { "0" => 'Value explanation'  } }
      }
    }
  end
end
