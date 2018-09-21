module Student
  class TeamLocationsController < StudentController
    before_action :require_current_team

    def edit
      @team = current_team
      @team.city ||= current_student.city
      @team.state_province ||= current_student.state_province
      @team.country ||= current_student.country
    end
  end
end
