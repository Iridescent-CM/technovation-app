# frozen_string_literal: true

require "prawn"
require "mini_magick"
require "tempfile"
require "./lib/certificate_field_mapping"
require "./lib/certificate_template_stripper"

module CertificateGenerators
  class Base
    FONT_DIR = Rails.root.join("vendor/fonts")

    def self.render(template_path:, layout:, values:)
      new(template_path, layout, values).render
    end

    def initialize(template_path, layout, values)
      @template_path = template_path
      @layout = layout
      @values = values
    end

    def render
      background = rasterize_background(@template_path)

      Prawn::Document.new(
        page_size: [@layout.fetch("page_width"), @layout.fetch("page_height")],
        margin: 0
      ) do |pdf|
        page_height = @layout.fetch("page_height")
        page_width = @layout.fetch("page_width")

        if background
          pdf.image(
            background.path,
            at: [0, page_height],
            width: page_width,
            height: page_height
          )
        end

        register_fonts(pdf)
        pdf.font "NotoSans"

        @layout.fetch("fields").each do |field_name, config|
          value_key = CertificateFieldMapping.value_key(field_name)
          text = @values[value_key]
          next if text.to_s.strip.empty?

          font_style = config.fetch("font_style", "normal").to_sym
          pdf.font "NotoSans", style: font_style
          pdf.fill_color config.fetch("color", "#000000").to_s.delete("#")

          pdf.text_box(
            text.to_s,
            at: [config.fetch("x"), config.fetch("y") + config.fetch("height")],
            width: config.fetch("width"),
            height: config.fetch("height"),
            size: config.fetch("size", 10),
            align: (config.fetch("align", "left")).to_sym,
            valign: :center,
            overflow: :shrink_to_fit
          )
        end
      end.render
    ensure
      background&.close!
    end

    private

    def register_fonts(pdf)
      pdf.font_families.update(
        "NotoSans" => {
          normal: FONT_DIR.join("NotoSans-Regular.ttf").to_s,
          bold: FONT_DIR.join("NotoSans-Bold.ttf").to_s
        }
      )
    end

    def rasterize_background(template_path)
      stripped_template = CertificateTemplateStripper.strip_form_fields(template_path)
      tempfile = Tempfile.new(["certificate-background", ".png"])

      MiniMagick::Tool::Convert.new do |convert|
        convert.density(150)
        convert << "#{stripped_template.path}[0]"
        convert << tempfile.path
      end

      tempfile
    rescue MiniMagick::Error, MiniMagick::Invalid
      nil
    ensure
      stripped_template&.close!
    end
  end
end
