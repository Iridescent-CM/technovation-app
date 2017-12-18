module Student
  class CodeChecklistsController < StudentController
    include CodeChecklistController
    before_action :require_current_team
  end
end
