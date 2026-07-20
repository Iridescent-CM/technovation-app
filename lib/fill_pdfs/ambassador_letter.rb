#!/usr/bin/env ruby

require "hexapdf"

module FillPdfs
  class AmbassadorLetter
    include FillPdfs

    def full_text
      ""
    end

    private

    def fill_form
      if !Rails.env.production? && skip_enabled?
        FileUtils.cp(pathname, tmp_output)
      elsif club_ambassador?
        fill_club_ambassador_letter!
      else
        FillPdfs.pdftk_wrapper.fill_form(
          pathname,
          tmp_output,
          field_values,
          flatten: true
        )
      end
    end

    def club_ambassador?
      account.club_ambassador? && !account.chapter_ambassador?
    end

    # Club ambassador templates reserve a wide AcroForm gap for Country that leaves
    # trailing whitespace after short names. Rewrite the body line so the country
    # sits in the sentence with normal spacing, using the form's InstrumentSans.
    def fill_club_ambassador_letter!
      country = recipient.region.to_s.strip
      doc = HexaPDF::Document.open(pathname)
      form = doc.acro_form
      page = doc.pages[0]
      raw = page[:Contents].stream.dup

      spacer = \
        "/Span<</ActualText<FEFF00090009>>> BDC \n" \
        "[( )-2510.2 ( )]TJ\n" \
        "EMC \n" \
        "27 0 Td\n" \
        "( )Tj\n" \
        "/Span<</ActualText<FEFF00090009>>> BDC \n" \
        "[( )-2600 ( )]TJ\n" \
        "EMC \n" \
        "6 0 Td\n" \
        "(           f)Tj\n" \
        "2.534 0 Td\n" \
        "[(or the T)106 (echno)13 (v)16 (a)14 (ti)2 (on G)-2 (irls 2)-14 (0)6 (25)43 (/)41 (2)-14 (0)6 (2)-14 (6 )]TJ\n"

      unless raw.include?(spacer)
        raise "Club ambassador letter template spacer pattern not found in #{pathname}"
      end

      phrase = " #{country} for the Technovation Girls 2025/2026 "
      safe = phrase.gsub("\\", "\\\\").gsub("(", "\\(").gsub(")", "\\)")

      instrument = form[:DR][:Font][:'InstrumentSans-Regular']
      page.resources[:Font][:Instr] = instrument

      # Absolute placement matches body baseline; continue "season." on the next line.
      season_y = 380.7602 - 14.4
      replacement = <<~EOS
        ET
        BT
        /Instr 12 Tf
        1 0 0 1 337.68 380.2602 Tm
        (#{safe})Tj
        ET
        BT
        /TT0 1 Tf
        12 0 0 12 81.1328 #{season_y.round(4)} Tm
      EOS

      raw = raw.sub(spacer, replacement)
      raw = raw.sub("0.018 Tc -0.018 Tw -35.534 -1.2 Td\n", "")
      page[:Contents].stream = raw

      if (country_field = form.field_by_name("Country"))
        country_field.each_widget { |widget| page[:Annots]&.delete(widget) }
        form[:Fields]&.delete(country_field)
      end

      form.field_by_name("Text Field 2").field_value = recipient.full_name
      form.create_appearances
      form.flatten
      doc.write(tmp_output, optimize: true)
    end
  end
end
