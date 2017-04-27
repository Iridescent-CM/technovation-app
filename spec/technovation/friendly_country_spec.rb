require "rails_helper"

RSpec.describe FriendlyCountry do
  it "returns nil if the object doesn't support the interface" do
    object = OpenStruct.new
    expect(FriendlyCountry.(object)).to be_nil
  end

  it "returns nil if the object has #country but is blank" do
    object = OpenStruct.new(country: "     ")
    expect(FriendlyCountry.(object)).to be_nil
  end

  it "returns the result of #country if Country[] is blank" do
    object = OpenStruct.new(country: "foo")
    expect(FriendlyCountry.(object)).to eq("foo")
  end

  it "returns a nicely formatted country ISO prefix with full name" do
    object = OpenStruct.new(country: "US")
    expect(FriendlyCountry.(object)).to eq("US - United States")
  end

  it "allows the caller to disable the prefix" do
    object = OpenStruct.new(country: "US")
    expect(FriendlyCountry.(object, prefix: false)).to eq("United States")
  end
end
