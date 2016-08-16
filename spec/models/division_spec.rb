require "rails_helper"

RSpec.describe Division do
  describe ".for" do
    it "is B for a team with all B division students" do
      student = FactoryGirl.create(:student, :on_team, date_of_birth: 13.years.ago)
      expect(Division.for(student.team)).to eq(Division.b)
    end

    it "is A if any team student is in A" do
      team = FactoryGirl.create(:team, members_count: 0)
      older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)
      younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)

      team.add_student(older_student)
      team.add_student(younger_student)

      expect(Division.for(team)).to eq(Division.a)
    end
  end
end
