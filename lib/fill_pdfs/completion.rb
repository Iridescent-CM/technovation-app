#!/usr/bin/env ruby

module FillPdfs
  class Completion
    include FillPdfs

    private
    def pathname
      './lib/Completion_nobleed-fillable2.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-completion-#{participant['id']}.pdf"
    end
  end
end
