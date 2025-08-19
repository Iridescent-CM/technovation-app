module Mentor
  class PublishedSubmissionConfirmationsController < MentorController
    include PublishedSubmissionConfirmationController
    layout "mentor_rebrand"
  end
end
