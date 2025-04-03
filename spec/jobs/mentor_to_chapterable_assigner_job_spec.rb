require "rails_helper"

RSpec.describe MentorToTeamChapterableAssignerJob do
  let(:mentor_profile) { instance_double(MentorProfile, id: 4210) }
  let(:team) { instance_double(Team, id: 8642) }

  before do
    allow(MentorProfile).to receive(:find).with(mentor_profile.id).and_return(mentor_profile)
    allow(Team).to receive(:find).with(team.id).and_return(team)
  end

  it "calls the service that will assign the mentor to the appropriate chapterables" do
    expect(MentorToTeamChapterableAssigner).to receive_message_chain(:new, :call)

    MentorToTeamChapterableAssignerJob.perform_now(
      mentor_profile_id: mentor_profile.id,
      team_id: team.id
    )
  end
end
