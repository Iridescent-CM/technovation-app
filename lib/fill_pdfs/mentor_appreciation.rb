#!/usr/bin/env ruby

require 'pdf_forms'
require 'pry'

module FillPdfs
  module MentorAppreciation
    def self.call(participant)
      pdftk = PdfForms::PdftkWrapper.new('/usr/bin/pdftk')
      pathname = './lib/RegionalAppreciation-mentor-RA-ME-SA_nobleed-fillable.pdf'
      tmp_output = "./tmp/#{Season.current.year}-mentor-apprecation-#{participant['id']}.pdf"

      region_name = "Valued support of Technovation #{participant['Region Name']} teams"
      season = "throughout the #{Season.current.year} season"

      field_values = {
        'Recipient Name' => participant['Recipient Name'],
        'description 1' => region_name,
        'description 2' => season
      }

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
