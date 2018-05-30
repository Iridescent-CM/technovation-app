#!/usr/bin/env ruby

module FillPdfs
  class Completion
    include FillPdfs

    def full_text(participant)
      "For her outstanding work as a member of Technovation " +
      "#{participant['region']} team " +
      "#{participant['teamName']} " +
      "to develop the mobile application " +
      "#{participant['mobileAppName']}."
    end

    private
    def pathname
      './lib/certs/2018/completion.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-completion-#{participant['id']}.pdf"
    end
  end
end
