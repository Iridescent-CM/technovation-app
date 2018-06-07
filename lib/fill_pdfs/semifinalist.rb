#!/usr/bin/env ruby

module FillPdfs
  class Semifinalist
    include FillPdfs

    def type
      "semifinalist"
    end

    def full_text
      "For her outstanding work as a member of Technovation " +
      "#{recipient.region} team #{recipient.teamName} " +
      "to develop the mobile application #{recipient.mobileAppName}."
    end
  end
end
