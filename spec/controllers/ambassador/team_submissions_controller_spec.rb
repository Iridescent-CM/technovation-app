require "rails_helper"

RSpec.describe Ambassador::TeamSubmissionsController do
  describe "GET #show" do
    context "as a chapter ambassador" do
      let(:chapter_ambassador) do
        FactoryBot.create(
          :chapter_ambassador,
          :not_assigned_to_chapter,
          national_view: false
        )
      end
      let(:brazil_chapter) do
        FactoryBot.create(
          :chapter,
          :brazil,
          primary_contact: chapter_ambassador.account
        )
      end

      before do
        chapter_ambassador.chapterable_assignments.create(
          chapterable: brazil_chapter,
          account: chapter_ambassador.account,
          season: Season.current.year,
          primary: true
        )

        sign_in(chapter_ambassador)
      end

      context "when viewing team submissions with `search_in_region` set to a truthy value" do
        let(:search_in_region) { 1 }

        context "when viewing a team submission in the same region" do
          let(:team_submission) { FactoryBot.create(:submission, :brazil) }

          before do
            get :show, params: {
              id: team_submission.id,
              search_in_region: search_in_region
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a team submission in a different region" do
          let(:team_submission) { FactoryBot.create(:submission, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: team_submission.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
