require "rails_helper"

RSpec.describe Admin::ClubsController do
  before do
    sign_in(:admin)
  end
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new club" do
        expect {
          post :create, params: {
            club: {name: "Hello World"}
          }
        }.to change { Club.count }.by(1)
      end

      it "adds the current season to the newly created club" do
        post :create, params: {
          club: {name: "Coding Club"}
        }

        expect(Club.last.seasons).to include(Season.current.year)
      end

      it "redirects to the created club" do
        post :create, params: {
          club: {name: "Hello World Again"}
        }
        expect(response).to redirect_to(admin_club_path(Club.last))
      end
    end

    context "with invalid attributes" do
      it "does not create a new club" do
        expect {
          post :create, params: {
            club: {name: ""}
          }
        }.not_to change { Club.count }
      end
    end
  end
end
