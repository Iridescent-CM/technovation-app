require "rails_helper"

RSpec.describe BooleanHelper do
  describe "humanize_boolean" do
    context "when a boolean value is true" do
      it "returns 'Yes'" do
        expect(humanize_boolean(true)).to eq("Yes")
      end
    end

    context "when a boolean value is false" do
      it "returns 'No'" do
        expect(humanize_boolean(false)).to eq("No")
      end
    end

    context "when a boolean value is nil" do
      it "returns '-'" do
        expect(humanize_boolean(nil)).to eq("-")
      end
    end
  end
end
