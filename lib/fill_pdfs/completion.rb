#!/usr/bin/env ruby

module FillPdfs
  class Completion
    include FillPdfs

    def full_text
      "For her outstanding work as a member of Technovation " +
      "#{recipient['region']} team " +
      "#{recipient['teamName']} " +
      "to develop the mobile application " +
      "#{recipient['mobileAppName']}."
    end

    private
    def pathname
      './lib/certs/2018/completion.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-completion-#{recipient['id']}.pdf"
    end
  end
end
