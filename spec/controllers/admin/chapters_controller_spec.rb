require "rails_helper"

RSpec.describe Admin::ChaptersController do
  before do
    sign_in(:admin)
  end
  describe "POST #create" do
    it "creates a new chapter" do
      expect {
        post :create, params: {
          chapter: {organization_name: "Hello World"}
        }
      }.to change { Chapter.count }.by(1)
    end

    it "adds the current season to the newly created chapter" do
      post :create, params: {
        chapter: {organization_name: "Coding Zone"}
      }

      expect(Chapter.last.seasons).to include(Season.current.year)
    end

    it "redirects to the created chapter" do
      post :create, params: {
        chapter: {organization_name: "Hello World Again"}
      }
      expect(response).to redirect_to(admin_chapter_path(Chapter.last))
    end
  end
end
