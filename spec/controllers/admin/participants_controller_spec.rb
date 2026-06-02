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

  describe "GET #index" do
    context "when arriving from a club's stats overview link (issue #6070)" do
      render_views

      let(:club) { FactoryBot.create(:club) }
      let!(:student) do
        student = FactoryBot.create(
          :student,
          :not_assigned_to_chapter,
          first_name: "Searchable",
          last_name: "Student"
        )
        student.account.update_columns(
          first_name: "Searchable",
          last_name: "Student",
          email: "searchable.student@example.com"
        )
        student.chapterable_assignments.create!(
          account: student.account,
          chapterable: club,
          season: Season.current.year,
          primary: true
        )
        student
      end

      let(:base_params) do
        {
          accounts_grid: {
            chapter: "",
            club: club.id,
            scope_names: ["student"],
            season: [Season.current.year]
          }
        }
      end

      it "returns 200 when filtering by name_email together with the club + scope_names + season filters" do
        get :index, params: base_params.deep_merge(
          accounts_grid: {name_email: "Searchable"}
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(student.account.email)
      end

      it "returns 200 when filtering by first_name (exact spelling) together with the club + scope_names + season filters" do
        get :index, params: base_params.deep_merge(
          accounts_grid: {first_name: "Searchable"}
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(student.account.email)
      end
    end
  end

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
