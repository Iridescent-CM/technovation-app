#!/usr/bin/env ruby

module FillPdfs
  class CertifiedJudge
    include FillPdfs

    def full_text
      "For their dedication to providing valuable feedback on 5 submissions as a Certified Judge in the #{recipient.season} season."
    end
  end
end
