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

  %w[student mentor judge chapter_ambassador club_ambassador].each do |scope|
    it "updates their contact info in the CRM when the email address on the account is changed (and only includes profile_type for students)" do
      profile = FactoryBot.create(
        scope,
        account: FactoryBot.create(
          :account,
          email: "old@oldtime.com"
        )
      )

      allow(CRM::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          email: "new@email.com"
        }
      }

      expect(CRM::UpsertContactInfoJob).to have_received(:perform_later)
        .with(
          account_id: profile.account_id,
          profile_type: profile.account.student_profile.present? ? "student" : nil
        ).at_least(:once)
    end

    it "updates their contact info in the CRM when the first name on the account is changed (and only includes profile_type for students)" do
      profile = FactoryBot.create(scope)

      allow(CRM::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          first_name: "someone cool"
        }
      }

      expect(CRM::UpsertContactInfoJob).to have_received(:perform_later)
        .with(
          account_id: profile.account_id,
          profile_type: profile.account.student_profile.present? ? "student" : nil
        ).at_least(:once)
    end

    it "updates their contact info in the CRM when the last name on the account is changed (and only includes profile_type for students)" do
      profile = FactoryBot.create(scope)

      allow(CRM::UpsertContactInfoJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.account_id,
        account: {
          last_name: "someone really cool"
        }
      }

      expect(CRM::UpsertContactInfoJob).to have_received(:perform_later)
        .with(
          account_id: profile.account_id,
          profile_type: profile.account.student_profile.present? ? "student" : nil
        ).at_least(:once)
    end
  end
end
