require "rails_helper"

RSpec.describe Admin::ParticipantsController do
  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)
  end

  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:junior_division_age) { Division::SENIOR_DIVISION_AGE - 1 }
  let(:junior_dob) { Division.cutoff_date - junior_division_age.years }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  it "reconsiders student's team division on dob change" do
    Timecop.freeze(Division.cutoff_date - 1.day) do
      student = FactoryBot.create(
        :student,
        account: FactoryBot.create(
          :account,
          email: "student@testing.com",
          date_of_birth: junior_dob,
        )
      )
      team = FactoryBot.create(:team)
      TeamRosterManaging.add(team, student)

      expect(team.division_name).to eq("junior")

      patch :update, params: {
        id: student.account_id,
        account: {
          date_of_birth: senior_dob,
        },
      }

      expect(team.reload.division_name).to eq("senior")
    end
  end

  %w{student mentor judge chapter_ambassador}.each do |scope|
    it "updates #{scope} newsletters with a change to the email address" do
      profile = FactoryBot.create(
        scope,
        account: FactoryBot.create(
          :account,
          email: "old@oldtime.com"
        )
      )

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          email: "new@email.com",
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(
          profile.account_id,
          "old@oldtime.com",
          scope.upcase,
        )
    end

    it "updates newsletters with a change to the address" do
      profile = FactoryBot.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          city: "Los Angeles",
          state_province: "CA",
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(
          profile.account_id,
          profile.account.email,
          scope.upcase,
        )
    end

    it "updates #{scope} newsletters with changes to first name" do
      profile = FactoryBot.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          first_name: "someone cool",
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(
          profile.account_id,
          profile.account.email,
          scope.upcase,
        )
    end

    it "updates #{scope} newsletters with changes to last name" do
      profile = FactoryBot.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          last_name: "someone really cool",
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(
          profile.account_id,
          profile.account.email,
          scope.upcase,
        )
    end
  end
end
