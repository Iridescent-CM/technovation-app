#!/usr/bin/env ruby

require 'pdf_forms'

require 'fill_pdfs/regional_grand_prize'
require 'fill_pdfs/mentor_appreciation'
require 'fill_pdfs/completion'

module FillPdfs
  PDFTK = PdfForms::PdftkWrapper.new('/usr/bin/pdftk')

  def self.call(participant, type)
    case type
    when :regional_grand_prize
      RegionalGrandPrize.new(participant).generate_certificate
    when :completion
      Completion.new(participant).generate_certificate
    when :mentor
      MentorAppreciation.new(participant).generate_certificate
    else
      raise "Unsupported type #{type}"
    end
  end

  attr_reader :participant

  def initialize(participant)
    @participant = participant
  end

  def generate_certificate
    PDFTK.fill_form(pathname, tmp_output, field_values, flatten: true)
    attach_uploaded_certificate_from_tmp_file_to_account
  end

  private
  def field_values
    Hash[ pdf.fields.map{|f| [f.name, participant[f.name]]} ]
  end

  def pdf
    PdfForms::Pdf.new(pathname, PDFTK)
  end

  def fill_form
    PDFTK.fill_form(pathname, tmp_output, field_values, flatten: true)
  end

  def attach_uploaded_certificate_from_tmp_file_to_account
    account = Account.find(participant['id'])
    file = File.new(tmp_output)

    account.certificates.create!({
      file: file,
      season: Season.current.year,
    })
  end
end
