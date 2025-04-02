require "rails_helper"

RSpec.describe MentorChapterableAssignmentsScrubberJob do
  let(:mentor_profile) { instance_double(MentorProfile, id: 9631) }

  before do
    allow(MentorProfile).to receive(:find).with(mentor_profile.id).and_return(mentor_profile)
  end

  it "calls the scrubber service that will clean up chapterable assignments for the mentor" do
    expect(MentorChapterableAssignmentsScrubber).to receive_message_chain(:new, :call)

    MentorChapterableAssignmentsScrubberJob.perform_now(mentor_profile_id: mentor_profile.id)
  end
end
