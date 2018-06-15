#!/usr/bin/env ruby

module FillPdfs
  class MentorAppreciation
    include FillPdfs

    def full_text
      "In recognition for your Excellence in mentoring " +
      "Technovation's #{recipient.team_name} team."
    end
  end
end
