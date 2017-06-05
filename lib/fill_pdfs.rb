#!/usr/bin/env ruby

require 'pdf_forms'

require 'fill_pdfs/regional_grand_prize'
require 'fill_pdfs/mentor_appreciation'
require 'fill_pdfs/completion'

module FillPdfs
  if !!ENV["PDFTK_PATH"]
    PDFTK = PdfForms::PdftkWrapper.new(ENV["PDFTK_PATH"])
  end

  def self.call(participant, type)
    return unless !!ENV["PDFTK_PATH"]

    case type.to_sym
    when :rpe_winner
      RegionalGrandPrize.new(participant, type).generate_certificate
    when :completion
      Completion.new(participant, type).generate_certificate
    when :appreciation
      MentorAppreciation.new(participant, type).generate_certificate
    else
      raise "Unsupported type #{type}"
    end
  end

  attr_reader :participant, :account, :type

  def initialize(participant, type)
    @participant = participant
    @type = type
    @account = Account.find(participant['id'])
  end

  def generate_certificate
    unless account.certificates.public_send(type).current.present?
      PDFTK.fill_form(pathname, tmp_output, field_values, flatten: true)
      attach_uploaded_certificate_from_tmp_file_to_account
    end

    account.certificates.public_send(type).current
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
    file = File.new(tmp_output)

    account.certificates.create!({
      file: file,
      season: Season.current.year,
      cert_type: type.to_sym,
    })
  end
end
