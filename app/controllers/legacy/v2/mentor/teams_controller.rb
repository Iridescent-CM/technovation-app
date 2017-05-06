module Legacy
  module V2
    module Mentor
      class TeamsController < MentorController
        include Concerns::TeamController

        def index
          @current_teams = current_mentor.teams.current
          @past_teams = current_mentor.teams.past
        end

        private
        def current_profile
          current_mentor
        end

        def account_type
          "mentor"
        end
      end
    end
  end
end
