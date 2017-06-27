require "spec_helper"
needs "technovation"
require "feature_accessing"

RSpec.describe FeatureAccessing do
  describe "#student_signup=" do
    context "valid input" do
      it "allows a collection of 'boolean' words and booleans" do
        (%w{on off yes no true false} + [true, false]).each do |good|
          feature_access = FeatureAccessing.new(student_signup: good)
          expect(feature_access).to be_valid
        end
      end
    end

    context "bad input" do
      it "refuses to save" do
        [nil, "", " ", "foo"].each do |bad|
          feature_access = FeatureAccessing.new(student_signup: bad)
          expect(feature_access.save).to be false
        end
      end

      it "adds an error to the attribute" do
        [nil, "", " ", "foo"].each do |bad|
          feature_access = FeatureAccessing.new(student_signup: bad)
          feature_access.valid?
          expect(feature_access.errors[:student_signup]).to eq(
            ["is not included in the list"]
          )
        end
      end
    end
  end
end
