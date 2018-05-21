#!/usr/bin/env ruby

module FillPdfs
  class Completion
    include FillPdfs

    private
    def pathname
      './lib/certs/2018/completion.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-completion-#{participant['id']}.pdf"
    end
  end
end
