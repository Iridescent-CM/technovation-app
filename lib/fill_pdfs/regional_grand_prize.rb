#!/usr/bin/env ruby

require 'pdf_forms'
require 'pry'

module FillPdfs
  module RegionalGrandPrize
    def self.call(participant)
      pdftk = PdfForms::PdftkWrapper.new('/usr/bin/pdftk')
      pathname = './lib/RegionalGrandPrize_nobleed-fillable.pdf'
      tmp_output = "./tmp/#{Season.current.year}-Regional-Grand-Prize-#{participant['id']}.pdf"
      pdf = PdfForms::Pdf.new(pathname, pdftk)

      field_values = Hash[ pdf.fields.map{|f| [f.name, participant[f.name]]} ]

      pdftk.fill_form pathname, tmp_output, field_values, flatten: true

      account = Account.find(participant['id'])
      file = File.new(tmp_output)

      account.certificates.create!({
        file: file,
        season: Season.current.year,
      })

      account.certificates.last.file_url
    end
  end
end
