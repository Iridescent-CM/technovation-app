require "rails_helper"

RSpec.describe StringHelper do
  describe "#escape_single_quotes" do
    it "escapes all single quotes in string" do
      escaped = helper.escape_single_quotes("Let's escape this string's quotes")
      expect(escaped).to eq("Let\\'s escape this string\\'s quotes")
    end

    it "handles nil" do
      expect(helper.escape_single_quotes(nil)).to be_nil
    end

    it "handles empty string" do
      expect(helper.escape_single_quotes("")).to be_empty
    end
  end
end