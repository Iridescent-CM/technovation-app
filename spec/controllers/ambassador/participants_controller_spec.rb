require "rails_helper"

RSpec.describe Ambassador::ParticipantsController do
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

      context "when viewing participants with `search_in_region` set to a truthy value" do
        let(:search_in_region) { 1 }

        context "when viewing a judge in the same region" do
          let(:judge) { FactoryBot.create(:judge, :brazil) }

          before do
            get :show, params: {
              id: judge.account.id,
              search_in_region: search_in_region
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a judge in a different region" do
          let(:judge) { FactoryBot.create(:judge, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: judge.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a mentor" do
          let(:mentor) { FactoryBot.create(:mentor) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: mentor.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a student" do
          let(:student) { FactoryBot.create(:student) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: student.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context "when a chapter ambassador has the 'national view' ability" do
        let(:national_view) { true }

        context "when viewing a participant in the chapter ambassador's region" do
          let(:brazil_student) { FactoryBot.create(:student, :brazil) }

          before do
            get :show, params: {
              id: brazil_student.account.id
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a participant that is not in the chapter ambassador's region" do
          let(:chicago_student) { FactoryBot.create(:student, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: chicago_student.account.id
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end

    context "as a club ambassador" do
      before do
        sign_in(:club_ambassador)
      end

      context "when viewing participants with `search_in_region` set to a truthy value" do
        let(:search_in_region) { 1 }

        context "when viewing a judge" do
          let(:judge) { FactoryBot.create(:judge) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: judge.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a mentor" do
          let(:mentor) { FactoryBot.create(:mentor) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: mentor.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a student" do
          let(:student) { FactoryBot.create(:student) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :show, params: {
                id: student.account.id,
                search_in_region: search_in_region
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
