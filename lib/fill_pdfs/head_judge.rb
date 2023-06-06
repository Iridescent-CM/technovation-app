#!/usr/bin/env ruby

module FillPdfs
  class HeadJudge
    include FillPdfs

    def full_text
      "For their dedication to providing valuable feedback on 6 to 10 submissions as a Head Judge in the #{recipient.season} season."
    end
  end
end
