require "rails_helper"

RSpec.describe Student::ProfilesController do
  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:junior_division_age) { Division::SENIOR_DIVISION_AGE - 1 }
  let(:junior_dob) { Division.cutoff_date - junior_division_age.years }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  it "sends a message to student's team to reconsider division on dob change" do
    Timecop.freeze(Division.cutoff_date - 1.day) do
      student = FactoryBot.create(
        :student,
        email: "student@testing.com",
        date_of_birth: junior_dob
      )
      team = FactoryBot.create(:team)
      TeamRosterManaging.add(team, student)

      expect(team.division_name).to eq("junior")

      sign_in(student)

      patch :update, params: {
        student_profile: {
          account_attributes: {
            id: student.account_id,
            date_of_birth: senior_dob
          },
        }
      }

      expect(team.reload.division_name).to eq("senior")
    end
  end
end
