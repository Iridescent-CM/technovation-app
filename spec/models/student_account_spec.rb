require "rails_helper"

RSpec.describe StudentAccount do
  describe "#age" do
    it "calculates the student's age" do
      student = FactoryGirl.create(:student, date_of_birth: "Feb 29, 2008")

      Timecop.freeze("March 1, 2017") do
        expect(student.age).to eq(9)
      end
    end
  end
end
