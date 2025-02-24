require "rails_helper"

RSpec.describe Admin::ChapterableAccountAssignmentsController do
  let(:club_ambassador) { FactoryBot.create(:club_ambassador) }
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:club) { FactoryBot.create(:club) }
  let(:chapter) { FactoryBot.create(:chapter) }

  before do
    sign_in(:admin)
  end

  describe "POST #create" do
    context "when assigning a chapterable to an account" do
      it "sets 'no chapterable selected' to nil for the account" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            club_id: club.id,
            chapter_id: nil,
            chapterable_type: "Club"
          }
        }

        expect(club_ambassador.account.reload.no_chapterable_selected).to be_nil
      end

      it "creates the assignment for this account" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            club_id: club.id,
            chapter_id: nil,
            chapterable_type: "Club"
          }
        }

        expect(club_ambassador.account.reload.current_club).to eq(club)
      end
    end

    context "when no chapterable is selected" do
      it "does not create the assignment" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            club_id: nil,
            chapter_id: nil,
            chapterable_type: "Club"
          }
        }
        expect(club_ambassador.account.reload.current_club).to be_blank
      end
    end

    context "assigning a club ambassador to a chapter" do
      it "does not create the assignment" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            club_id: nil,
            chapter_id: chapter.id,
            chapterable_type: "Chapter"
          }
        }
        expect(club_ambassador.account.reload.current_chapterable_assignment).to be_blank
      end
    end

    context "assigning a chapter ambassador to a club" do
      it "does not create the assignment" do
        post :create, params: {
          account_id: chapter_ambassador.account.id,
          chapterable_account_assignment: {
            club_id: club.id,
            chapter_id: nil,
            chapterable_type: "Club"
          }
        }
        expect(chapter_ambassador.account.reload.current_chapterable_assignment).to be_blank
      end
    end
  end
end
