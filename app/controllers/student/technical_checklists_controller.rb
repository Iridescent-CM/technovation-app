module Student
  class TechnicalChecklistsController < StudentController
    include TechnicalChecklistController
    before_action :require_current_team
  end
end
