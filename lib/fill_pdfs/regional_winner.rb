#!/usr/bin/env ruby

module FillPdfs
  class RegionalWinner
    include FillPdfs

    private
    def pathname
      './lib/certs/2018/student/regional_winner.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-Regional-Winner-#{recipient['id']}.pdf"
    end
  end
end
