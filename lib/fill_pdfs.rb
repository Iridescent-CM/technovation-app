#!/usr/bin/env ruby

require "./lib/certificate_layouts"
require "./lib/certificate_generators/base"
require "./lib/certificate_generators/generator"
require "./lib/certificate_template_paths"

Dir[Rails.root.join("lib/fill_pdfs/*.rb")].each { |f| require f }

module FillPdfs
  def self.call(account, **options)
    season = options.fetch(:season) { Season.current.year }

    DetermineCertificates.new(account).needed.each do |recipient|
      fill(recipient)
    end
  end

  def self.fill(recipient)
    build_filler(recipient).generate_certificate
  end

  def self.render_pdf(recipient)
    build_filler(recipient).render_pdf
  end

  def self.build_filler(recipient)
    certificate_type = recipient.certificate_type

    generator_klass_name = "fill_pdfs/#{certificate_type}"
    generator_klass = generator_klass_name.camelize.safe_constantize

    if !!generator_klass
      generator_klass.new(recipient, certificate_type)
    else
      GenericPDFFiller.new(recipient, certificate_type)
    end
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
    create_certificate_record
    account.certificates.public_send(type).current
  end

  def render_pdf
    layout = CertificateLayouts.for(template_path: pathname)
    pdf_data(layout)
  end

  private

  def skip_enabled?
    ENV.fetch("DO_NOT_FILL_CERTIFICATES", false)
  end

  def create_certificate_record
    attrs = {season: season, cert_type: type.to_sym}
    attrs[:team] = team if team.present?

    account.certificates.create!(attrs)
  end

  def pdf_data(layout)
    if !Rails.env.production? && skip_enabled?
      File.binread(pathname)
    else
      CertificateGenerators::Generator.generate(
        filler: self,
        template_path: pathname,
        layout: layout
      )
    end
  end

  def pathname
    CertificateTemplatePaths.for(recipient: recipient, type: type, season: season)
  end

  class GenericPDFFiller
    include FillPdfs

    def full_text
      ""
    end
  end
end
