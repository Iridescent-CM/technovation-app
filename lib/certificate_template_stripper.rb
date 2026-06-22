# frozen_string_literal: true

require "hexapdf"
require "tempfile"

module CertificateTemplateStripper
  module_function

  def strip_form_fields(template_path)
    output = Tempfile.new(["certificate-template", ".pdf"])

    doc = HexaPDF::Document.open(template_path)
    doc.catalog.delete(:AcroForm) if doc.catalog.key?(:AcroForm)

    doc.pages.each do |page|
      page.delete(:Annots) if page.key?(:Annots)
    end

    doc.write(output.path, validate: false)
    output
  end
end
