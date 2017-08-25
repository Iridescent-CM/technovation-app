class Student::MentorsController < StudentController
  def show
    @mentor = MentorProfile.find(params.fetch(:id))
    @mentor_invite = MentorInvite.new
  end
end
