#!/usr/bin/env ruby

module FillPdfs
  class MentorAppreciation
    include FillPdfs

    private
    def pathname
     './lib/RegionalAppreciation-mentor-RA-ME-SA_nobleed-June.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-mentor-apprecation-#{participant['id']}.pdf"
    end

    def field_values
      region_name = "Valued support of Technovation #{participant['Region Name']} teams"
      season = "throughout the #{Season.current.year} season"

      {
        'Recipient Name' => participant['Recipient Name'],
        'description 1' => region_name,
        'description 2' => season,
      }
    end
  end
end
