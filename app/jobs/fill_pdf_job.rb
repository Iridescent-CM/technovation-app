require './lib/fill_pdfs'

class FillPdfJob < ApplicationJob
  def perform(recipient, certificate_type)
    FillPdfs.(recipient, certificate_type.to_sym)
  end
end
