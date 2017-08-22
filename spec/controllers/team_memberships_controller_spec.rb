require "rails_helper"

RSpec.describe "Team Memberships Controllers" do
  before { Timecop.travel(Division.cutoff_date - 1.day) }
  after { Timecop.return }

  describe Student::TeamMembershipsController do
    describe "DELETE #destroy" do
      it "reconsiders divisions" do
        team = FactoryGirl.create(:team, members_count: 0)

        older_student = FactoryGirl.create(
          :student,
          date_of_birth: 15.years.ago
        )
        younger_student = FactoryGirl.create(
          :student,
          date_of_birth: 14.years.ago
        )

        TeamRosterManaging.add(team, [younger_student, older_student])

        expect(team.reload).to be_senior

        sign_in(older_student)

        delete :destroy, params: { id: team.id }

        expect(team.reload).to be_junior
      end
    end
  end

  %w{regional_ambassador admin}.each do |scope|
    describe "#{scope.camelize}::TeamMembershipsController".constantize do
      describe "DELETE #destroy" do
        it "reconsiders divisions" do
          team = FactoryGirl.create(:team, members_count: 0)

          older_student = FactoryGirl.create(
            :student,
            date_of_birth: 15.years.ago
          )
          younger_student = FactoryGirl.create(
            :student,
            date_of_birth: 14.years.ago
          )

          TeamRosterManaging.add(team, [younger_student, older_student])

          expect(team.reload).to be_senior

          profile = FactoryGirl.create(scope)
          sign_in(profile)

          delete :destroy, params: {
            id: team.id,
            account_id: older_student.account_id,
          }

          expect(team.reload).to be_junior
        end
      end
    end
  end
end
