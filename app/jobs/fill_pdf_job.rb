require './lib/fill_pdfs'

class FillPdfJob < ApplicationJob
  def perform(participant, type)
    FillPdfs.(participant, type.to_sym)
  end
end
