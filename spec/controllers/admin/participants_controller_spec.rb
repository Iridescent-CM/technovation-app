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
          date_of_birth: junior_dob
        )
      )
      team = FactoryBot.create(:team)
      TeamRosterManaging.add(team, student)

      expect(team.division_name).to eq("junior")

      patch :update, params: {
        id: student.account_id,
        account: {
          date_of_birth: senior_dob
        }
      }

      expect(team.reload.division_name).to eq("senior")
    end
  end

  %w[student mentor judge chapter_ambassador].each do |scope|
    it "updates their contact info in the CRM when the email address on the account is changed" do
      profile = FactoryBot.create(
        scope,
        account: FactoryBot.create(
          :account,
          email: "old@oldtime.com"
        )
      )

      allow(Crm::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          email: "new@email.com"
        }
      }

      expect(Crm::UpsertContactInfoJob).to have_received(:perform_later)
        .with(account_id: profile.account_id)
    end

    it "updates their contact info in the CRM when the first name on the account is changed" do
      profile = FactoryBot.create(scope)

      allow(Crm::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          first_name: "someone cool"
        }
      }

      expect(Crm::UpsertContactInfoJob).to have_received(:perform_later)
        .with(account_id: profile.account_id)
    end

    it "updates their contact info in the CRM when the last name on the account is changed" do
      profile = FactoryBot.create(scope)

      allow(Crm::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          last_name: "someone really cool"
        }
      }

      expect(Crm::UpsertContactInfoJob).to have_received(:perform_later)
        .with(account_id: profile.account_id)
    end
  end
end
