require "spec_helper"
require "./app/technovation/friendly_country"

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
    module FakeCountry
      def self.[](country)
        OpenStruct.new(:blank? => true)
      end
    end

    stub_const("Country", FakeCountry)

    object = OpenStruct.new(country: "foo")
    expect(FriendlyCountry.(object)).to eq("foo")
  end

  it "returns a nicely formatted country ISO prefix with full name" do
    module FakeCountry
      def self.[](country)
        OpenStruct.new(name: "My Country")
      end
    end

    stub_const("Country", FakeCountry)

    object = OpenStruct.new(country: "MC")
    expect(FriendlyCountry.(object)).to eq("MC - My Country")
  end

  it "allows the caller to disable the prefix" do
    module FakeCountry
      def self.[](country)
        OpenStruct.new(name: "My Country")
      end
    end

    stub_const("Country", FakeCountry)

    object = OpenStruct.new(country: "MC")

    expect(FriendlyCountry.(object, prefix: false)).to eq("My Country")
  end
end
