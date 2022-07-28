#!/usr/bin/env ruby

module FillPdfs
  class Quarterfinalist
    include FillPdfs

    def full_text
      "For their outstanding work as a member of Technovation #{recipient.region}, #{recipient.team_name}, to develop the project #{recipient.mobile_app_name}."
    end
  end
end
