require "rails_helper"

RSpec.describe ChapterAmbassador::RegionalPitchEventsController do
  describe "POST #create" do
    context "when event creation is enabled" do
      it "creates an event and redirects to show view" do
        sign_in(:chapter_ambassador)
        allow(SeasonToggles).to receive(:create_regional_pitch_event?).and_return(true)

        expect {
          post :create, params: {
            regional_pitch_event: FactoryBot.attributes_for(:event)
          }
        }.to change { RegionalPitchEvent.count }.by(1)

        event = RegionalPitchEvent.last
        expect(response).to redirect_to(chapter_ambassador_event_path(event))
      end
    end

    context "when event creation is disabled" do
      it "does not create an event and redirects to the events list view" do
        sign_in(:chapter_ambassador)
        allow(SeasonToggles).to receive(:create_regional_pitch_event?).and_return(false)

        expect {
          post :create, params: {
            regional_pitch_event: FactoryBot.attributes_for(:event)
          }
        }.not_to change { RegionalPitchEvent.count }

        expect(response).to redirect_to(chapter_ambassador_events_list_path)
      end
    end
  end

  describe "PATCH #update" do
    it "updates an event and redirects to the show page" do
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
