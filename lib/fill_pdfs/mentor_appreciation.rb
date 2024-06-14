#!/usr/bin/env ruby

module FillPdfs
  class MentorAppreciation
    include FillPdfs

    def full_text
      "For their outstanding work as a Technovation Mentor in the #{recipient.season}  season. They supported Technovation Girls participants in finding a problem they were passionate about solving with technology, building the idea, testing it with users, and pitching to industry professionals . All while providing project management support, encouragement and contributing to participant’s sense of belonging in STEM. Their efforts are changing the world through technology."
    end
  end
end
