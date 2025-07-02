#!/usr/bin/env ruby

module FillPdfs
  class SilverJudge
    include FillPdfs

    def full_text
      if recipient.account.judge_profile.live_event?
        "For their dedication to providing personalized and actionable feedback on technology based projects during a Regional Pitch Event in the Technovation Girls #{recipient.season} program season. This feedback will further enrich Technovation Girls participants' learning journeys."
      else
        "For their dedication to providing personalized and actionable feedback on 6-10 technology based projects in the Technovation Girls #{recipient.season} program season. This feedback will further enrich Technovation Girls participants' learning journeys."
      end
    end
  end
end
