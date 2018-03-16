require "rails_helper"

RSpec.describe RegionalAmbassador::RegionalPitchEventsController do
  describe "POST #create" do
    it "responds with the create json and the update url" do
      sign_in(:ra)

      post :create, params: {
        format: :json,
        regional_pitch_event: FactoryBot.attributes_for(:event),
      }

      event = RegionalPitchEvent.last
      json = event.reload.to_list_json.merge({
        url: regional_ambassador_regional_pitch_event_path(
          event,
          format: :json
        ),
      })

      expect(response.body).to eq(json.to_json)
    end
  end

  describe "PATCH #update" do
    it "responds with the update json and the update url" do
      sign_in(:ra)

      event = FactoryBot.create(:event)

      patch :update, params: {
        format: :json,
        id: event.id,
        regional_pitch_event: {
          name: "hello world",
        },
      }

      json = event.reload.to_list_json.merge({
        url: regional_ambassador_regional_pitch_event_path(
          event,
          format: :json
        ),
      })

      expect(response.body).to eq(json.to_json)
    end
  end
end
