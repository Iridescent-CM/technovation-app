require "rails_helper"

RSpec.describe Student::RegionalPitchEventsFinderController do
  describe "GET #show" do
    it "does not load events when RPE selection is off" do
      student = FactoryBot.create(:student, :submitted, :junior)
      event = FactoryBot.create(:event, :junior)

      sign_in(student)

      SeasonToggles.select_regional_pitch_event_on!
      get :show
      expect(assigns[:regional_events]).to eq([event])

      SeasonToggles.select_regional_pitch_event_off!
      get :show
      expect(assigns[:regional_events]).to be_empty
    end
  end
end
