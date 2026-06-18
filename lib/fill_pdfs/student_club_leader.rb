#!/usr/bin/env ruby

module FillPdfs
  class StudentClubLeader
    include FillPdfs

    def full_text
      "For their outstanding work as a Technovation Student Club Leader in the #{recipient.season} season. They supported Technovation Girls participants and volunteers in their community."
    end
  end
end
