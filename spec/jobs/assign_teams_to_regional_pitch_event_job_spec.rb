require "rails_helper"

RSpec.describe AssignTeamsToRegionalPitchEventJob do
  let(:regional_pitch_event) { instance_double(RegionalPitchEvent, id: 8192) }

  before do
    allow(RegionalPitchEvent).to receive(:find).with(regional_pitch_event.id).and_return(regional_pitch_event)
  end

  it "calls the service that will assign the mentor to the appropriate chapterables" do
    expect(DataProcessors::AssignTeamsToRegionalPitchEvent).to receive_message_chain(:new, :call)

    AssignTeamsToRegionalPitchEventJob.perform_now(
      regional_pitch_event_id: regional_pitch_event.id,
      team_ids: [1, 2, 3]
    )
  end
end
