#!/usr/bin/env ruby

module FillPdfs
  class Completion
    include FillPdfs

    def type
      "completion"
    end

    def full_text
      "For her outstanding work as a member of Technovation " +
      "#{recipient.region} team " +
      "#{recipient.teamName} " +
      "to develop the mobile application " +
      "#{recipient.mobileAppName}."
    end
  end
end
