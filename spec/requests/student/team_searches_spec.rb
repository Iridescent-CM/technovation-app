require "rails_helper"

RSpec.describe Student::TeamSearchesController do
  let(:student_account) { FactoryBot.create(:account) }
  let(:student_profile) do
    FactoryBot.create(
      :student_profile,
      :geocoded,
      account: student_account
    )
  end

  describe "GET #new" do
    before do
      sign_in student_profile
    end

    context "when a team is accepting student join requests" do
      let!(:team) do
        FactoryBot.create(
          :team,
          accepting_student_requests: true
        )
      end

      it "includes them in search results" do
        get new_student_team_search_path(nearby: :anywhere)
        expect(response.body).to include(team.name)
      end
    end

    context "when a team is not accepting student join requests" do
      let!(:team) do
        FactoryBot.create(
          :team,
          accepting_student_requests: false
        )
      end

      it "excludes them from search results" do
        get new_student_team_search_path(nearby: :anywhere)
        expect(response.body).not_to include(team.name)
      end
    end
  end
end
