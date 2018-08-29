require "rails_helper"

RSpec.describe FriendlyCountry do
  it "returns blank if the object doesn't support the interface" do
    object = OpenStruct.new
    expect(FriendlyCountry.(object)).to be_blank
  end

  it "returns blank if the object has #country but is blank" do
    object = OpenStruct.new(address_details: "     ")
    expect(FriendlyCountry.(object)).to be_blank
  end

  it "returns the result of #country if Geocoder.search() is blank" do
    object = OpenStruct.new(address_details: "x")
    expect(FriendlyCountry.(object)).to eq("x")
  end

  it "returns a nicely formatted country ISO prefix with full name" do
    object = OpenStruct.new(address_details: "US")
    expect(FriendlyCountry.(object)).to eq("US - United States")
  end

  it "allows the caller to disable the prefix" do
    object = OpenStruct.new(address_details: "US")
    expect(FriendlyCountry.(object, prefix: false)).to eq("United States")
  end
end
