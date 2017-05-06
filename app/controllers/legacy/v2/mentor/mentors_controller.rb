module Legacy
  module V2
    class Mentor::MentorsController < MentorController
      def show
        @mentor = MentorProfile.find(params.fetch(:id))
        @mentor_invite = MentorInvite.new
      end
    end
  end
end
