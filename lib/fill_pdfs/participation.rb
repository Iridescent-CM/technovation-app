#!/usr/bin/env ruby

module FillPdfs
  class Participation
    include FillPdfs

    def type
      "participation"
    end

    private
    def pathname
      './lib/certs/2018/participation.pdf'
    end

    def tmp_output
      "./tmp/#{Season.current.year}-participation-#{recipient.id}.pdf"
    end
  end
end
