#!/usr/bin/env ruby

require 'pdf_forms'

Dir[Rails.root.join('lib/fill_pdfs/*.rb')].each { |f| require f }

module FillPdfs
  def self.pdftk_wrapper
    return @@pdftk_wrapper if defined?(@@pdftk_wrapper)
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

    @@pdftk_wrapper = PdfForms::PdftkWrapper.new(ENV.fetch("PDFTK_PATH"))
  end

  if Rails.env.production?
    # forcing this var to be set in production
    ENV.fetch("LD_LIBRARY_PATH")
  end

  def self.call(account, **options)
    season = options.fetch(:season) { Season.current.year }

    DetermineCertificates.new(account).needed.each do |recipient|
      fill(recipient)
    end
  end

  def self.fill(recipient)
    certificate_type = recipient.certificate_type

    generator_klass_name = "fill_pdfs/#{certificate_type}"
    generator_klass = generator_klass_name.camelize.safe_constantize

    generator = if !!generator_klass
                  generator_klass.new(recipient, certificate_type)
                else
                  GenericPDFFiller.new(recipient, certificate_type)
                end

    generator.generate_certificate
  end

  attr_reader :recipient, :account, :team, :type, :season

  def initialize(recipient, type)
    @recipient = recipient
    @account = recipient.account
    @team = recipient.team
    @season = recipient.season
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
    PdfForms::Pdf.new(pathname, FillPdfs.pdftk_wrapper)
  end

  def fill_form
    FillPdfs.pdftk_wrapper.fill_form(
      pathname,
      tmp_output,
      field_values,
      flatten: true
    )
  end

  def attach_uploaded_certificate_from_tmp_file_to_account
    file = File.new(tmp_output)

    attrs = {
      file: file,
      season: season,
      cert_type: type.to_sym,
    }

    attrs.merge!(team: team) if team.present?

    account.certificates.create!(attrs)
  end

  def get_value(recipient, field_name)
    if ["full_text"].include?(field_name)
      self.public_send(field_name)
    else
      recipient.public_send(field_name)
    end
  end

  def pathname
    "./lib/certs/#{season}/#{type}.pdf"
  end

  def tmp_output
    "./tmp/#{season}-#{type}-#{recipient.id}-#{recipient.team_id}.pdf"
  end

  class GenericPDFFiller
    include FillPdfs
  end
end
