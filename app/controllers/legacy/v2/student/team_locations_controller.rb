module Legacy
  module V2
    module Student
      class TeamLocationsController < StudentController
        def edit
          @team = current_team
          @team.city ||= current_student.city
          @team.state_province ||= current_student.state_province
          @team.country ||= current_student.country
        end
      end
    end
  end
end
