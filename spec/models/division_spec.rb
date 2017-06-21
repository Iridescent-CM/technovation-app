require "rails_helper"

RSpec.describe Division do
  describe ".for" do
    it "is Junior for a team with all Junior division students" do
      student = FactoryGirl.create(:student, :on_team, date_of_birth: 14.years.ago)
      expect(Division.for(student.team)).to eq(Division.junior)
    end

    it "is Senior if the student is 15 by Aug 1 of season year" do
      student = FactoryGirl.create(
        :student,
        date_of_birth: Date.new(Season.current.year - 15, 8, 1)
      )

      Timecop.freeze(Date.new(Season.current.year - 1, 9, 1)) do
        expect(Division.for(student)).to eq(Division.senior)
      end
    end

    it "is Senior if any team student is in Senior" do
      team = FactoryGirl.create(:team, members_count: 0)
      older_student = FactoryGirl.create(:student, date_of_birth: 15.years.ago)
      younger_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

      TeamRosterManaging.add(team, [older_student, younger_student])

      expect(Division.for(team)).to eq(Division.senior)
    end
  end
end
