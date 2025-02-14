require "rails_helper"

RSpec.describe Ambassador::ParticipantsController do
  describe "GET #show" do
    context "as a chapter ambassador" do
      before do
        sign_in(:chapter_ambassador)
      end

      context "when viewing participants with `search_in_region` set to a truthy value" do
        let(:search_in_region) { 1 }

        context "when viewing a judge" do
          let(:judge) { FactoryBot.create(:judge) }

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
