#!/usr/bin/env ruby

module FillPdfs
  class Coach
    include FillPdfs

    def full_text
      "For their outstanding work as a Technovation Coach in the #{recipient.season} season. They supported Technovation Girls participants in finding a problem they were passionate about solving with technology, building the idea, testing it with users, and pitching to industry professionals. All while providing project management support, encouragement and contributing to participants' sense of belonging in STEM."
    end
  end
end
