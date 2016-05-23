require 'spec_helper'
require './app/models/score'

RSpec.describe "list fields by category" do
  subject(:fields) { Score.fields(:category_name) }

  it "is empty when the category does not exist" do
    allow(Score).to receive(:config) { {} }
    expect(fields).to be_empty
  end

  it "is empty when the category does not have any fields" do
    allow(Score).to receive(:config) { { "category_name" => {} } }
    expect(fields).to be_empty
  end

  it "lists all category fields" do
    allow(Score).to receive(:config) { category_has_fields_config }
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
