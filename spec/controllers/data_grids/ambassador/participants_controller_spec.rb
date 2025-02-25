require "rails_helper"

RSpec.describe DataGrids::Ambassador::ParticipantsController do
  describe "GET #index" do
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

      it "returns an OK 200 status code" do
        get :index

        expect(response.status).to eq(200)
      end

      context "when a chapter ambassador has the 'national view' ability" do
        let(:national_view) { true }

        context "when viewing a chapter in the ChA's chapter's region" do
          let(:another_brazil_chapter) { FactoryBot.create(:chapter, :brazil) }

          before do
            get :index, params: {
              accounts_grid: {
                chapter: another_brazil_chapter.id
              }
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a chapter that is not in the ChA's chapter's region" do
          let(:chicago_chapter) { FactoryBot.create(:chapter, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :index, params: {
                accounts_grid: {
                  chapter: chicago_chapter.id
                }
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when viewing a club in the ChA's chapter's region" do
          let(:brazil_club) { FactoryBot.create(:club, :brazil) }

          before do
            get :index, params: {
              accounts_grid: {
                club: brazil_club.id
              }
            }
          end

          it "returns an OK 200 success status code" do
            expect(response.status).to eq(200)
          end
        end

        context "when viewing a club that is not in the ChA's chapter's region" do
          let(:chicago_club) { FactoryBot.create(:club, :chicago) }

          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :index, params: {
                accounts_grid: {
                  club: chicago_club.id
                }
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context "when a chapter ambassador does not have the 'national view' ability" do
        let(:national_view) { false }

        context "when trying to use the [:accounts_grid][:chapter] param" do
          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :index, params: {
                accounts_grid: {
                  chapter: 456
                }
              }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when trying to use the [:accounts_grid][:club] param" do
          it "raises an 'ActiveRecord::RecordNotFound' error" do
            expect {
              get :index, params: {
                accounts_grid: {
                  club: 789
                }
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

      it "returns an OK 200 status code" do
        get :index

        expect(response.status).to eq(200)
      end
    end
  end
end
