require "rails_helper"

RSpec.describe "Submissions" do
  describe ".closing_date" do
    it "reads the setting submissionClose key" do
      Setting.create!(key: "submissionClose",
                      value: "2014-06-01")

      expect(Submissions.closing_date).to eq(Date.parse("2014-06-01"))
    end
  end
end
