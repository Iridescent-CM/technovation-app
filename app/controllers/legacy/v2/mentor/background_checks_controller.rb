module Legacy
  module V2
    module Mentor
      class BackgroundChecksController < MentorController
        include BackgroundCheckController
        private
        def current_profile
          current_mentor
        end
      end
    end
  end
end
