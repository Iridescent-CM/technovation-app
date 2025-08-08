class Mentor::MentorsController < MentorController
  layout "mentor_rebrand"

  def show
    @mentor = MentorProfile.find(params.fetch(:id))
    @mentor_invite = MentorInvite.new
  end
end
