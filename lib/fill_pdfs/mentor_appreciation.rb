#!/usr/bin/env ruby

module FillPdfs
  class MentorAppreciation
    include FillPdfs

    def full_text
      "For their dedication to supporting girls to become leaders and problem-solvers in their community as a Technovation mentor during the #{recipient.season} season."
    end
  end
end
