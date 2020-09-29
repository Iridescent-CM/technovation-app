require "rails_helper"

RSpec.describe Division do
  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:junior_division_age) { Division::SENIOR_DIVISION_AGE - 1 }
  let(:junior_dob) { Division.cutoff_date - junior_division_age.years }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  describe ".for" do
    it "is Junior for a team with all Junior division students" do
      student = FactoryBot.create(
        :student,
        :on_team,
        date_of_birth: junior_dob
      )
      expect(Division.for(student.team)).to eq(Division.junior)
    end

    it "is Senior if the student is 15 by the cutoff date" do
      student = FactoryBot.create(
        :student,
        date_of_birth: senior_dob
      )

      expect(Division.for(student)).to eq(Division.senior)
    end

    it "is Senior if any team student is in Senior" do
      team = FactoryBot.create(:team)
      older_student = FactoryBot.create(:student, date_of_birth: senior_dob)
      younger_student = FactoryBot.create(:student, date_of_birth: junior_dob)

      TeamRosterManaging.add(team, [older_student, younger_student])

      expect(Division.for(team)).to eq(Division.senior)
    end
  end
end
