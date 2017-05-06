module Legacy
  module V2
    module Mentor
      class TechnicalChecklistsController < MentorController
        def edit
          redirect_to mentor_dashboard_path
        end

        def update
          redirect_to mentor_dashboard_path
        end
      end
    end
  end
end
