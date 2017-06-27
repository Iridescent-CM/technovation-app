require "spec_helper"
needs "technovation"
require "feature_accessing"

RSpec.describe FeatureAccessing do
  context "bad input" do
    it "refuses to save" do
      [nil, "", " ", "foo"].each do |bad|
        feature_access = FeatureAccessing.new(student_signup: bad)
        expect(feature_access.valid?).to be false
        expect(feature_access.save).to be false
      end
    end

    it "adds an error to the attribute" do
      [nil, "", " "].each do |bad|
        feature_access = FeatureAccessing.new(student_signup: bad)
        feature_access.valid?
        expect(feature_access.errors[:student_signup]).to eq(["can't be blank"])
      end
    end
  end
end
