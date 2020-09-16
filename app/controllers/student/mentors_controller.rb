class Student::MentorsController < StudentController
  def show
    @mentor = MentorProfile.find(params.fetch(:id))
    @mentor_invite = MentorInvite.new
    if current_team.present? && @mentor.requested_to_join?(current_team)
      @mentor_request = @mentor.join_requests.pending.where(team: current_team).first
    end
  end
end
