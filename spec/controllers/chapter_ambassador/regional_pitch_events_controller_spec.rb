require "rails_helper"

RSpec.describe ChapterAmbassador::RegionalPitchEventsController do
  describe "POST #create" do
    it "creates an event and redirects to show page" do
      sign_in(:chapter_ambassador)

      post :create, params: {
        regional_pitch_event: FactoryBot.attributes_for(:event)
      }

      event = RegionalPitchEvent.last

      expect(response).to redirect_to(chapter_ambassador_event_path(event))
    end
  end

  describe "PATCH #update" do
    it "updates an event and redirects to the show page " do
      sign_in(:chapter_ambassador)

      event = FactoryBot.create(:event)

      patch :update, params: {
        id: event.id,
        regional_pitch_event: {
          name: "hello world"
        }
      }

      expect(event.reload.name).to eq("hello world")
      expect(response).to redirect_to(chapter_ambassador_event_path(event))
    end
  end
end
