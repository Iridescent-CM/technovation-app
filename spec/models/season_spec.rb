require "rails_helper"

RSpec.describe Season do
  describe ".current" do
    context "before switch date" do
      it "is the current year" do
        Timecop.freeze(Date.new(2010, Season.switch_month - 1, 28)) do
          expect(Season.current.year).to eq(2010)
        end
      end
    end

    context "on and after switch date" do
      it "is the next year" do
        Timecop.freeze(Date.new(2010, Season.switch_month, Season.switch_day)) do
          expect(Season.current.year).to eq(2011)
        end
      end
    end
  end
end
