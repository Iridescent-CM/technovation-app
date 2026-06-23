# frozen_string_literal: true

require "yaml"
require "hexapdf"

module CertificateLayoutExtractor
  module_function

  def extract_all!(root: Rails.root)
    Dir.glob(root.join("lib/certs/*/*.pdf")).sort.each do |path|
      relative = path.sub("#{root}/lib/certs/", "")
      season, basename = relative.split("/", 2)
      layout_name = basename.sub(/\.pdf\z/, "")

      layout = extract_file(path)
      next if layout.fetch("fields").empty?

      out_dir = root.join("config/certificate_layouts", season)
      FileUtils.mkdir_p(out_dir)
      File.write(out_dir.join("#{layout_name}.yml"), layout.to_yaml)
    end
  end

  def extract_file(path)
    doc = HexaPDF::Document.open(path)
    page = doc.pages[0]
    media = page.box(:media)

    fields = {}
    acro = doc.acro_form
    if acro
      acro.each_field do |field|
        name = field.full_field_name
        widget = field.each_widget.first
        next unless widget

        rect = widget[:Rect]
        appearance = parse_default_appearance(field[:DA])

        fields[name] = {
          "x" => rect[0].to_f.round(1),
          "y" => rect[1].to_f.round(1),
          "width" => (rect[2] - rect[0]).to_f.round(1),
          "height" => (rect[3] - rect[1]).to_f.round(1),
          "align" => "left",
          "size" => appearance[:size] || default_size_for(name),
          "color" => hex_color(appearance[:color]),
          "font_style" => appearance[:font_style] || "normal"
        }
      end
    end

    {
      "page_width" => media.width.to_f.round(1),
      "page_height" => media.height.to_f.round(1),
      "fields" => fields
    }
  end

  def parse_default_appearance(da)
    return {} unless da

    appearance = {font_style: "normal"}

    if da.match?(/Bold|,Bold/i)
      appearance[:font_style] = "bold"
    end

    if (match = da.match(/(\d+(?:\.\d+)?)\s+Tf/))
      appearance[:size] = match[1].to_f.round
    end

    if (match = da.match(/([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+rg/))
      r, g, b = match.captures.map { |c| (c.to_f * 255).round }
      appearance[:color] = format("%02x%02x%02x", r, g, b)
    elsif (match = da.match(/([\d.]+)\s+g/))
      gray = (match[1].to_f * 255).round
      appearance[:color] = format("%02x%02x%02x", gray, gray, gray)
    end

    appearance.transform_keys(&:to_s)
  end

  def default_size_for(field_name)
    CertificateFieldMapping.recipient_name_field?(field_name) ? 14 : 10
  end

  def hex_color(value)
    "##{value || "000000"}"
  end
end
