require "rails_helper"
require "./lib/certificate_layouts"
require "./lib/certificate_generators/base"
require "./lib/certificate_generators/generator"

RSpec.describe CertificateGenerators::Base do
  let(:template_path) { "./lib/certs/2026/mentor.pdf" }
  let(:layout) { CertificateLayouts.for(template_path: template_path) }
  let(:values) do
    {
      recipient_name: "Андрій Riepin",
      full_text: "For their outstanding work as a Technovation Mentor."
    }
  end

  describe ".render" do
    it "returns a PDF containing the recipient name and description" do
      pdf_data = described_class.render(
        template_path: template_path,
        layout: layout,
        values: values
      )

      expect(pdf_data).to start_with("%PDF")

      reader = PDF::Reader.new(StringIO.new(pdf_data))
      text = reader.pages.map(&:text).join(" ")

      expect(text).to include("Андрій Riepin")
      expect(text).to include("Technovation Mentor")
    end
  end
end

RSpec.describe CertificateLayouts do
  describe ".for" do
    it "loads a layout for a season template" do
      layout = described_class.for(template_path: "./lib/certs/2024/participation.pdf")

      expect(layout.fetch("page_width")).to eq(792.0)
      expect(layout.fetch("fields").keys).to include("full_name", "full_text")
      expect(layout.dig("fields", "full_name", "color")).to eq("#0076cf")
    end

    it "raises when no layout exists" do
      expect {
        described_class.for(template_path: "./lib/certs/2099/missing.pdf")
      }.to raise_error(ArgumentError, /Certificate layout not found/)
    end
  end
end
