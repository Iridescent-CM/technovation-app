#!/usr/bin/env ruby

module FillPdfs
  class RegionalGrandPrize
    include FillPdfs

    private

    def pathname
      "./lib/certs/2018/regional-grand-prize.pdf"
    end

    def tmp_output
      "./tmp/#{Season.current.year}-Regional-Grand-Prize-#{participant["id"]}.pdf"
    end
  end
end
