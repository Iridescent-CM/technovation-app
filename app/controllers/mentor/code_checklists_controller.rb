module Mentor
  class CodeChecklistsController < MentorController
    include CodeChecklistController
    before_action :require_current_team
  end
end
