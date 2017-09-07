module Student
  class TeamMembershipsController < StudentController
    def destroy
      team = current_student.teams.find(params.fetch(:id))
      member = current_student.team.students.find(params.fetch(:member_id))
      TeamRosterManaging.remove(team, member)

      if member == current_student
        redirect_to student_dashboard_path,
          success: "You have removed yourself from #{team.name}"
      else
        redirect_to student_team_path(team),
          success: "#{member.full_name} has been removed from #{team.name}"
      end
    end
  end
end
