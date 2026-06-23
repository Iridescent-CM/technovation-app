require "rails_helper"
require "./lib/certificate_template_stripper"

RSpec.describe CertificateTemplateStripper do
  describe ".strip_form_fields" do
    it "removes acroform fields from judge templates with placeholder defaults" do
      stripped = described_class.strip_form_fields("./lib/certs/2021/head_judge.pdf")

      doc = HexaPDF::Document.open(stripped.path)
      expect(doc.acro_form).to be_nil
      expect(doc.pages[0][:Annots]).to be_nil
    ensure
      stripped&.close!
    end
  end
end
