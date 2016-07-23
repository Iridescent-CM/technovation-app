class Student::MentorsController < StudentController
  def show
    @mentor = MentorAccount.find(params.fetch(:id))
    @mentor_invite = MentorInvite.new
  end
end
