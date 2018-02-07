module Mentor
  class PendingTeammatesController < MentorController
    def index
      render "student/pending_teammates/index"
    end
  end
end
