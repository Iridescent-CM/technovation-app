require "rails_helper"

RSpec.describe Admin::ChapterableAccountAssignmentsController do
  let(:club_ambassador) { FactoryBot.create(:club_ambassador) }
  let(:club) { FactoryBot.create(:club) }

  before do
    sign_in(:admin)
  end

  describe "POST #create" do
    context "when assigning a chapterable to an account" do
      it "sets 'no chapterable selected' to nil for the account" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            chapterable_id: club.id,
            chapterable_type: "Club"
          }
        }

        expect(club_ambassador.account.reload.no_chapterable_selected).to be_nil
      end

      it "creates a chapterable assignment for this account" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            chapterable_id: club.id,
            chapterable_type: "Club"
          }
        }

        expect(club_ambassador.account.reload.current_club).to eq(club)
      end
    end

    context "when no chapterable is selected" do
      it "does not create a chapterable assignment" do
        post :create, params: {
          account_id: club_ambassador.account.id,
          chapterable_account_assignment: {
            chapterable_id: nil,
            chapterable_type: "Club"
          }
        }

        expect(club_ambassador.account.reload.current_club).to be_empty
      end
    end
  end
end
