require "rails_helper"

RSpec.describe "Submissions" do
  describe ".closing_date" do
    it "reads the setting submissionClose key" do
      Setting.create!(key: "submissionClose",
                      value: "2014-06-01")

      expect(Submissions.closing_date).to eq(Date.parse("2014-06-01"))
    end
  end

  describe ".opening_date" do
    it "reads the setting submissionOpen key" do
      Setting.create!(key: "submissionOpen",
                      value: "2014-05-01")

      expect(Submissions.opening_date).to eq(Date.parse("2014-05-01"))
    end
  end

  describe ".open?" do
    before do
      Submissions.open!("2015-04-14")
      Submissions.close!("2015-04-16")
    end

    it "is open on the submissionOpen date" do
      Timecop.freeze("2015-04-14") do
        expect(Submissions.open?).to be true
      end
    end

    it "is not open before the submissionOpen date" do
      Timecop.freeze("2015-04-13") do
        expect(Submissions.open?).to be false
      end
    end

    it "is open after the submissionOpen date" do
      Timecop.freeze("2015-04-15") do
        expect(Submissions.open?).to be true
      end
    end

    it "is open on the submissionClose date" do
      Timecop.freeze("2015-04-16") do
        expect(Submissions.open?).to be true
      end
    end

    it "is not open after the submissionClose date" do
      Timecop.freeze("2015-04-17") do
        expect(Submissions.open?).to be false
      end
    end
  end
end
