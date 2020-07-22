require "rails_helper"

RSpec.describe "Team Memberships Controllers" do
  before { Timecop.travel(Division.cutoff_date - 1.day) }
  after { Timecop.return }

  describe Student::TeamMembershipsController do
    describe "DELETE #destroy" do
      it "reconsiders divisions" do
        team = FactoryBot.create(:team)

        older_student = FactoryBot.create(
          :student,
          date_of_birth: 15.years.ago
        )
        younger_student = FactoryBot.create(
          :student,
          date_of_birth: 13.years.ago
        )

        TeamRosterManaging.add(team, [younger_student, older_student])

        expect(team.reload).to be_senior

        sign_in(older_student)

        delete :destroy, params: { id: team.id, member_id: older_student.id }

        expect(team.reload).to be_junior
      end
    end
  end

  %w{chapter_ambassador admin}.each do |scope|
    describe "#{scope.camelize}::TeamMembershipsController".constantize do
      describe "DELETE #destroy" do
        it "reconsiders divisions" do
          team = FactoryBot.create(:team)

          older_student = FactoryBot.create(
            :student,
            date_of_birth: 15.years.ago
          )
          younger_student = FactoryBot.create(
            :student,
            date_of_birth: 13.years.ago
          )

          TeamRosterManaging.add(team, [younger_student, older_student])

          expect(team.reload).to be_senior

          profile = FactoryBot.create(scope)
          sign_in(profile)

          delete :destroy, params: {
            id: team.id,
            member_id: older_student.id,
            member_type: "StudentProfile",
          }

          expect(team.reload).to be_junior
        end
      end
    end
  end
end
