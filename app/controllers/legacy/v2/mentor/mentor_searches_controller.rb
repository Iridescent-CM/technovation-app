module Legacy
  module V2
    module Mentor
      class MentorSearchesController < MentorController
        include ::MentorSearchesController

        private
        def user
          current_mentor
        end
      end
    end
  end
end
