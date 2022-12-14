require "rails_helper"

RSpec.describe Season do
  describe ".next" do
    it "returns next year" do
      date = Season.switch_date(2011)

      Timecop.freeze(date) do
        expect(Season.next.year).to eq(2013)
      end
    end
  end

  describe ".current" do
    context "around NYE" do
      it "uses PST" do
        time = Time.new(2011, 1, 1, 0, 0, 0, 0)

        Timecop.freeze(time) do
          allow(Date).to receive(:today).and_return(
            Time.now.utc.to_date
          )
          expect(Season.current.year).to eq(2011)
        end
      end
    end

    context "before switch date" do
      it "is the current year" do
        Timecop.freeze(Date.new(2010, Season::START_MONTH - 1, 28)) do
          expect(Season.current.year).to eq(2010)
        end
      end
    end

    context "on and after switch date" do
      it "is the next year" do
        Timecop.freeze(
          Date.new(
            2010,
            Season::START_MONTH,
            Season::START_DAY
          )
        ) do
          expect(Season.current.year).to eq(2011)
        end
      end
    end
  end

  describe ".submission_deadline" do
    let(:deadline) { Time.zone.local(2019, 4, 25, 17) }

    before do
      allow(ImportantDates).to receive(:submission_deadline).at_least(:once).and_return(deadline)
    end

    it "includes a human-readable date in the PDT time zone" do
      expect(Season.submission_deadline).to include("April 25, 5PM PDT")
    end

    it "includes a human-readable date in the WAT time zone" do
      expect(Season.submission_deadline).to include("April 26")
      expect(Season.submission_deadline).to include("1AM WAT")
    end

    it "includes a human-readable date in the CEST time zone" do
      expect(Season.submission_deadline).to include("2AM CEST")
    end

    it "includes a human-readable date in the IST time zone" do
      expect(Season.submission_deadline).to include("530AM IST")
    end
  end
end
