class MentorChapterableAssignmentsScrubberJob < ActiveJob::Base
  queue_as :default

  def perform(mentor_profile_id:)
    mentor_profile = MentorProfile.find(mentor_profile_id)

    MentorChapterableAssignmentsScrubber.new(mentor_profile: mentor_profile).call
  end
end
