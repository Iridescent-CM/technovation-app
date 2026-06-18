#!/usr/bin/env ruby

module FillPdfs
  class AmbassadorAppreciation
    include FillPdfs

    def full_text
      role = if account.chapter_ambassador?
        "Chapter Ambassador"
      else
        "Club Ambassador"
      end

      "For their outstanding work as a Technovation #{role} in the #{recipient.season} season. They supported Technovation Girls participants and volunteers in their community, helping to build and coordinate the program in their area."
    end
  end
end
