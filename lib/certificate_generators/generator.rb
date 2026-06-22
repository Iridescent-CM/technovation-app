# frozen_string_literal: true

require "./lib/certificate_field_mapping"

module CertificateGenerators
  class Generator
    def self.generate(filler:, template_path:, layout:)
      recipient_name = filler.recipient.full_name

      values = {
        recipient_name: recipient_name,
        full_name: recipient_name,
        full_text: filler.full_text,
        division: filler.recipient.division,
        team_name: filler.recipient.team_name,
        app_name: filler.recipient.mobile_app_name,
        region: filler.recipient.region
      }.compact

      Base.render(
        template_path: template_path,
        layout: layout,
        values: values
      )
    end
  end
end
