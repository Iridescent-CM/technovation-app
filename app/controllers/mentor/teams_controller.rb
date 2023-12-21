module Mentor
  class TeamsController < MentorController
    include TeamController

    before_action :require_onboarded

    private

    def current_profile
      current_mentor
    end
  end
end
