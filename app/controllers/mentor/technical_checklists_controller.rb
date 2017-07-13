module Mentor
  class TechnicalChecklistsController < MentorController
    include TechnicalChecklistController
    before_action :require_current_team
  end
end
