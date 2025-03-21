require "rails_helper"

RSpec.describe Ambassador::ScoresController do
  describe "GET #show" do
    context "as a chapter ambassador" do
      let(:chapter_ambassador) do
        FactoryBot.create(
          :chapter_ambassador,
          :not_assigned_to_chapter,
          national_view: national_view
        )
      end
      let(:brazil_chapter) do
        FactoryBot.create(
          :chapter,
          :brazil,
          primary_contact: chapter_ambassador.account
        )
      end
      let(:national_view) { false }

      before do
        chapter_ambassador.chapterable_assignments.create(
          chapterable: brazil_chapter,
          account: chapter_ambassador.account,
          season: Season.current.year,
          primary: true
        )

        sign_in(chapter_ambassador)
      end

      context "when a chapter ambassador has the 'national view' ability" do
        let(:national_view) { true }

        context "when viewing a score for a team in the chapter ambassador's region" do
          let(:brazil_score) { FactoryBot.create(:score, :brazil) }

          before do
            get :show, params: {
              id: brazil_score.id
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a score for a team that is not in the chapter ambassador's region" do
          let(:chicago_score) { FactoryBot.create(:score, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: chicago_score.id
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context "when a chapter ambassador does not have the 'national view' ability" do
        let(:national_view) { false }

        context "when viewing a score for a student who is assigned to the chapter ambassador's chapter" do
          let(:brazil_student) { FactoryBot.create(:student, :brazil, :not_assigned_to_chapter) }
          let(:brazil_submission) { FactoryBot.create(:submission, :brazil, :complete) }
          let(:brazil_score) { FactoryBot.create(:score, team_submission: brazil_submission) }

          before do
            brazil_student.chapterable_assignments.create(
              account: brazil_student.account,
              chapterable: brazil_chapter
            )

            brazil_submission.team.students << brazil_student
            brazil_submission.save

            get :show, params: {
              id: brazil_score.id
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a score for a team in the chapter ambassador's region, but not assigned to their chapter" do
          let(:brazil_score) { FactoryBot.create(:score, :brazil) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: brazil_score.id
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a score for a team that is not in the chapter ambassador's region" do
          let(:chicago_score) { FactoryBot.create(:score, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: chicago_score.id
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
