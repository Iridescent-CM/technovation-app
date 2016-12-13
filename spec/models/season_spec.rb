require "rails_helper"

RSpec.describe Season do
  describe ".current" do
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
