require "rails_helper"

RSpec.describe AssignTeamsToRegionalPitchEventJob do
  let(:regional_pitch_event) {
    instance_double(RegionalPitchEvent,
      id: 8192,
      name: "My Local Event")
  }
  let(:account) {
    instance_double(Account,
      id: 16384,
      first_name: "Amy",
      email: "amy@example.com",
      locale: "en")
  }

  before do
    allow(RegionalPitchEvent).to receive(:find).with(regional_pitch_event.id).and_return(regional_pitch_event)

    allow(Account).to receive(:find).with(account.id).and_return(account)

    allow(DataProcessors::AssignTeamsToRegionalPitchEvent).to receive_message_chain(:new, :call).and_return(assignment_result)
  end

  let(:assignment_result) { double("assignment_result", results: []) }

  it "calls the service that will assign teams to the specified event" do
    expect(DataProcessors::AssignTeamsToRegionalPitchEvent).to receive_message_chain(:new, :call)

    AssignTeamsToRegionalPitchEventJob.perform_now(
      regional_pitch_event_id: regional_pitch_event.id,
      account_id: account.id,
      team_ids: [1, 2, 3]
    )
  end

  it "calls the ambassador's 'assigned teams to event' mailer" do
    expect(AmbassadorMailer).to receive_message_chain(:assigned_teams_to_event, :deliver_now)

    AssignTeamsToRegionalPitchEventJob.perform_now(
      regional_pitch_event_id: regional_pitch_event.id,
      account_id: account.id,
      team_ids: [1, 2, 3]
    )
  end
end
