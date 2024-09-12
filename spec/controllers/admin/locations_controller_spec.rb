require "rails_helper"

RSpec.describe Admin::LocationsController do
  let(:admin) { FactoryBot.create(:admin) }
  let(:chapter) { FactoryBot.create(:chapter) }

  before do
    sign_in(admin)
  end

  describe "PATCH #update" do
    it "updates the chapter location" do
      patch :update, params: {
        chapter_id: chapter.id,
        admin_location: {
          city: "Chicago"
        }
      }

      chapter.reload
      expect(chapter.city).to eq("Chicago")
      expect(chapter.state_province).to eq("IL")
      expect(chapter.country).to eq("United States")
    end
  end
end
