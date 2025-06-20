module Mentor
  class TeamsController < MentorController
    include TeamController
    layout "mentor_rebrand"

    before_action :require_onboarded

    private

    def current_profile
      current_mentor
    end
  end
end
