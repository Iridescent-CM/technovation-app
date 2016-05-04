require "rails_helper"

RSpec.describe Setting do
  describe ".submissionOpen?" do
    before do
      Submissions.open!("2015-04-14")
      Submissions.close!("2015-04-16")
    end

    it "is open on the submissionOpen date" do
      Timecop.freeze("2015-04-14") do
        expect(Setting.submissionOpen?).to be true
      end
    end

    it "is not open before the submissionOpen date" do
      Timecop.freeze("2015-04-13") do
        expect(Setting.submissionOpen?).to be false
      end
    end

    it "is open after the submissionOpen date" do
      Timecop.freeze("2015-04-15") do
        expect(Setting.submissionOpen?).to be true
      end
    end

    it "is open on the submissionClose date" do
      Timecop.freeze("2015-04-16") do
        expect(Setting.submissionOpen?).to be true
      end
    end

    it "is not open after the submissionClose date" do
      Timecop.freeze("2015-04-17") do
        expect(Setting.submissionOpen?).to be false
      end
    end
  end
end
