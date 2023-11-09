require "rails_helper"

RSpec.describe "Regional Pitch Event Settings" do
  before do
    allow(SeasonToggles).to receive(:create_regional_pitch_event?)
      .and_return(true)
  end

  it "returns regional pitch event settings" do
    get api_regional_pitch_events_settings_path

    expect(JSON.parse(response.body)).to eq(
      {
        "canCreateEvents" => true
      }
    )
  end
end
