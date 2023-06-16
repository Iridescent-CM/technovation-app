#!/usr/bin/env ruby

module FillPdfs
  class HeadJudge
    include FillPdfs

    def full_text
      if recipient.account.judge_profile.live_event?
        "For their participation in a Regional Pitch Event in the #{recipient.season} season."
      else
        "For their dedication to providing valuable feedback on 6 to 10 submissions as a Head Judge in the #{recipient.season} season."
      end
    end
  end
end
