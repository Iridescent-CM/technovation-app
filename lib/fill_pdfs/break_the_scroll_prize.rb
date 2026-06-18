#!/usr/bin/env ruby

module FillPdfs
  class BreakTheScrollPrize
    include FillPdfs

    def full_text
      "For their outstanding work as a member of Technovation #{recipient.region}, team #{recipient.team_name}, to develop the project #{recipient.mobile_app_name} and win the Break the Scroll Prize in the #{recipient.season} season."
    end
  end
end
