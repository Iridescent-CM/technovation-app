require "rails_helper"

RSpec.describe Season do
  describe ".current" do
    it "starts at 9am PST" do
      start_time = Season.current.starts_at.strftime('%-I:%M %P %Z')
      expect(start_time).to eq('9:00 am PST')
    end

    context "before Aug 1" do
      it "is the current year" do
        Timecop.freeze(Date.new(2010, 7, 31)) do
          expect(Season.current.year).to eq(2010)
        end
      end
    end

    context "on and after Aug 1" do
      it "is the next year" do
        Timecop.freeze(Date.new(2010, 8, 1)) do
          expect(Season.current.year).to eq(2011)
        end
      end
    end
  end
end
