#!/usr/bin/env ruby

module FillPdfs
  class Participation
    include FillPdfs

    def full_text
      "TODO: This cert is not at all complete!"
    end

    def type
      "participation"
    end

    private
    def pathname
      './lib/certs/2018/completion.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-completion-#{recipient.id}.pdf"
    end
  end
end
