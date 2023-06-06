#!/usr/bin/env ruby

module FillPdfs
  class Semifinalist
    include FillPdfs

    def full_text
      "For their outstanding work as a member of team #{recipient.team_name} from Technovation #{recipient.region}, developing the project #{recipient.mobile_app_name} in the #{recipient.season} season."
    end
  end
end
