#!/usr/bin/env ruby

module FillPdfs
  class Semifinalist
    include FillPdfs

    def full_text
      "For her outstanding work as a member of Technovation " +
      "#{recipient.region} team #{recipient.team_name} " +
      "to develop the mobile application #{recipient.mobile_app_name} for the #{recipient.season} Technovation Girls season."
    end
  end
end
