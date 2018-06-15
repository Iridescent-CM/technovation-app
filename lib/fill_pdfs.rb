#!/usr/bin/env ruby

require 'pdf_forms'

Dir[Rails.root.join('lib/fill_pdfs/*.rb')].each { |f| require f }

module FillPdfs
  # PROD settings:
  # heroku config:set LD_LIBRARY_PATH=/app/vendor/pdftk/lib --app APPNAME
  # heroku config:set PDFTK_PATH=pdftk --app APPNAME
  #
  # DEV settings:
  # -- use `which pdftk` to find your executable path
  # -- install via homebrew or apt-get if needed
  #
  # assuming this typical executable path:
  # echo "PDFTK_PATH=/usr/bin/pdftk" >> .env

  PDFTK = PdfForms::PdftkWrapper.new(ENV.fetch("PDFTK_PATH"))

  if Rails.env.production?
    # forcing this var to be set in production
    ENV.fetch("LD_LIBRARY_PATH")
  end

  def self.call(account, team = nil)
    recipient = CertificateRecipient.new(account, team)

    recipient.needed_certificate_types.each do |certificate_type|
      generator_klass_name = "fill_pdfs/#{certificate_type}"
      generator_klass = generator_klass_name.camelize.safe_constantize

      generator = if !!generator_klass
                    generator_klass.new(recipient, certificate_type)
                  else
                    GenericPDFFiller.new(recipient, certificate_type)
                  end

      generator.generate_certificate
    end
  end

  attr_reader :recipient, :account, :team, :type

  def initialize(recipient, type)
    @recipient = recipient
    @account = recipient.account
    @team = recipient.team
    @type = type
  end

  def generate_certificate
    raise "PDF is not editable" if pdf.fields.empty?
    fill_form
    attach_uploaded_certificate_from_tmp_file_to_account
    account.certificates.public_send(type).current
  end

  private
  def field_values
    Hash[ pdf.fields.map { |f| [f.name, get_value(recipient, f.name)] } ]
  end

  def pdf
    raise IOError, "file not found - #{pathname}" unless File.exist?(pathname)
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
      team: team,
    })
  end

  def get_value(recipient, field_name)
    if ["fullText", "Description.Page 1"].include?(field_name)
      full_text
    elsif ["fullName", "Firstname Lastname.Page 1"].include?(field_name)
      recipient.full_name
    else
      recipient.public_send(field_name)
    end
  end

  def pathname
    "./lib/certs/#{Season.current.year}/#{type}.pdf"
  end

  def tmp_output
    "./tmp/#{Season.current.year}-#{type}-#{recipient.id}-#{recipient.team_id}.pdf"
  end

  class GenericPDFFiller
    include FillPdfs
  end
end