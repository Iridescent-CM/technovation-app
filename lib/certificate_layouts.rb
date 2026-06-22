# frozen_string_literal: true

require "yaml"

module CertificateLayouts
  module_function

  def for(template_path:)
    relative = template_path
      .sub(%r{\A\./}, "")
      .sub(%r{\Alib/certs/}, "")
      .sub(/\.pdf\z/, "")

    season, layout_name = relative.split("/", 2)
    path = Rails.root.join("config/certificate_layouts", season, "#{layout_name}.yml")

    raise ArgumentError, "Certificate layout not found: #{path}" unless File.exist?(path)

    YAML.load_file(path)
  end
end
