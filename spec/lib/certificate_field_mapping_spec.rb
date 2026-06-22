require "rails_helper"
require "./lib/certificate_field_mapping"

RSpec.describe CertificateFieldMapping do
  describe ".value_key" do
    it "maps recipient name field aliases to :recipient_name" do
      expect(described_class.value_key("full_name")).to eq(:recipient_name)
      expect(described_class.value_key("full name")).to eq(:recipient_name)
      expect(described_class.value_key("fullName")).to eq(:recipient_name)
      expect(described_class.value_key("FullName")).to eq(:recipient_name)
      expect(described_class.value_key("FULL_NAME")).to eq(:recipient_name)
      expect(described_class.value_key("Recipient 2")).to eq(:recipient_name)
      expect(described_class.value_key("RecipientName 5")).to eq(:recipient_name)
      expect(described_class.value_key("Recipient Name")).to eq(:recipient_name)
    end

    it "maps description field aliases to :full_text" do
      expect(described_class.value_key("MentorDescription")).to eq(:full_text)
      expect(described_class.value_key("Text Field 9")).to eq(:full_text)
    end

    it "maps division field aliases to :division" do
      expect(described_class.value_key("division")).to eq(:division)
      expect(described_class.value_key("LEVEL")).to eq(:division)
    end
  end
end
