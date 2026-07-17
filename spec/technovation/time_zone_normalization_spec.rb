require "rails_helper"

RSpec.describe TimeZoneNormalization do
  describe ".canonical_for" do
    it "maps legacy IANA identifiers to canonical names" do
      expect(described_class.canonical_for("Europe/Kiev")).to eq("Europe/Kyiv")
      expect(described_class.canonical_for("Asia/Calcutta")).to eq("Asia/Kolkata")
      expect(described_class.canonical_for("America/Buenos_Aires")).to eq("America/Argentina/Buenos_Aires")
    end

    it "returns the input when no mapping exists" do
      expect(described_class.canonical_for("America/Chicago")).to eq("America/Chicago")
    end

    it "returns nil for blank input" do
      expect(described_class.canonical_for(nil)).to be_nil
      expect(described_class.canonical_for("")).to be_nil
    end
  end

  describe ".normalize" do
    it "returns canonical names for legacy identifiers" do
      expect(described_class.normalize("Europe/Kiev")).to eq("Europe/Kyiv")
      expect(described_class.normalize("Asia/Calcutta")).to eq("Asia/Kolkata")
      expect(described_class.normalize("America/Buenos_Aires")).to eq("America/Argentina/Buenos_Aires")
    end

    it "returns valid identifiers unchanged" do
      expect(described_class.normalize("America/Chicago")).to eq("America/Chicago")
    end

    it "returns nil for unknown identifiers" do
      expect(described_class.normalize("Not/A/Timezone")).to be_nil
    end

    it "returns nil for blank input" do
      expect(described_class.normalize(nil)).to be_nil
      expect(described_class.normalize("")).to be_nil
    end

    it "falls back to the original name when canonical is unavailable" do
      allow(Time).to receive(:find_zone).and_call_original
      allow(Time).to receive(:find_zone).with("Europe/Kyiv").and_return(nil)

      expect(described_class.normalize("Europe/Kiev")).to eq("Europe/Kiev")
    end
  end
end
