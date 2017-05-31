require "rails_helper"

RSpec.describe FriendlySubregion do
  it "returns nil if the object doesn't support the interface" do
    object = OpenStruct.new
    expect(FriendlySubregion.(object)).to be_nil
  end

  it "returns nil if the object has #country but is blank" do
    object = OpenStruct.new(country: "     ")
    expect(FriendlySubregion.(object)).to be_nil
  end

  it "returns nil if the object has #state_province but is blank" do
    object = OpenStruct.new(country: "US", state_province: "   ")
    expect(FriendlySubregion.(object)).to be_nil
  end

  it "returns the result of #state_province if friendly result is blank" do
    object = OpenStruct.new(country: "US", state_province: "foo")
    expect(FriendlySubregion.(object)).to eq("foo")
  end

  it "returns a nicely formatted subregion ISO prefix with full name" do
    object = OpenStruct.new(country: "US", state_province: "MI")
    expect(FriendlySubregion.(object)).to eq("MI - Michigan")
  end

  it "allows the caller to disable the prefix" do
    object = OpenStruct.new(country: "US", state_province: "MI")
    expect(FriendlySubregion.(object, prefix: false)).to eq("Michigan")
  end
end
