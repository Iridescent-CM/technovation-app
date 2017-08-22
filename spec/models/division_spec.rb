require "rails_helper"

RSpec.describe Division do
  describe ".for" do
    it "is Junior for a team with all Junior division students" do
      Timecop.freeze(Division.cutoff_date - 1.day) do
        student = FactoryGirl.create(
          :student,
          :on_team,
          date_of_birth: 14.years.ago
        )
        expect(Division.for(student.team)).to eq(Division.junior)
      end
    end

    it "is Senior if the student is 15 by the cutoff date" do
      student = FactoryGirl.create(
        :student,
        date_of_birth: Division.cutoff_date - 15.years
      )

      Timecop.freeze(Division.cutoff_date + 1.day) do
        expect(Division.for(student)).to eq(Division.senior)
      end
    end

    it "is Senior if any team student is in Senior" do
      Timecop.freeze(Division.cutoff_date - 1.day) do
        team = FactoryGirl.create(:team, members_count: 0)
        older_student = FactoryGirl.create(:student, date_of_birth: 15.years.ago)
        younger_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

        TeamRosterManaging.add(team, [older_student, younger_student])

        expect(Division.for(team)).to eq(Division.senior)
      end
    end
  end
end
