#!/usr/bin/env ruby

require 'pdf_forms'

require 'fill_pdfs/completion'
require 'fill_pdfs/regional_winner'

module FillPdfs
  # PROD settings:
  # heroku config:set LD_LIBRARY_PATH=/app/vendor/pdftk/lib --app APPNAME
  # heroku config:set PDFTK_PATH: /app/vendor/pdftk/bin/pdftk --app APPNAME
  #
  # DEV settings:
  # -- use `which pdftk` to find your executable path
  # -- install via homebrew or apt-get if needed
  #
  # assuming this typical path:
  # echo "PDFTK_PATH=/usr/bin/pdftk" >> .env

  PDFTK = PdfForms::PdftkWrapper.new(ENV.fetch("PDFTK_PATH"))

  if Rails.env.production?
    # forcing this var to be set in production
    ENV.fetch("LD_LIBRARY_PATH")
  end

  def self.call(pdf_field_value_pairs, certificate_type)
    certificate_generator = nil

    case certificate_type.to_sym
    when :completion
      certificate_generator = Completion.new(
        pdf_field_value_pairs,
        certificate_type
      )
    when :rpe_winner
      certificate_generator = RegionalWinner.new(
        pdf_field_value_pairs,
        certificate_type
      )
    else
      raise "Unsupported certificate type #{certificate_type}"
    end

    certificate_generator.generate_certificate
  end

  attr_reader :participant, :account, :type

  def initialize(participant, type)
    @participant = participant
    @type = type
    @account = Account.find(participant['id'])
  end

  def generate_certificate
    unless account.certificates.public_send(type).current.present?
      fill_form
      attach_uploaded_certificate_from_tmp_file_to_account
    end

    account.certificates.public_send(type).current
  end

  private
  def field_values
    Hash[ pdf.fields.map { |f| [f.name, get_value(participant, f.name)] } ]
  end

  def pdf
    PdfForms::Pdf.new(pathname, PDFTK)
  end

  def fill_form
    PDFTK.fill_form(
      pathname,
      tmp_output,
      field_values,
      flatten: true
    )
  end

  def attach_uploaded_certificate_from_tmp_file_to_account
    file = File.new(tmp_output)

    account.certificates.create!({
      file: file,
      season: Season.current.year,
      cert_type: type.to_sym,
    })
  end

  def get_value(participant, field_name)
    if field_name === "fullText"
      full_text(participant)
    else
      participant[field_name]
    end
  end
end
