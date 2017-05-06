module Legacy
  module V2
    module Admin
      class MentorDropOutsController < AdminController
        def create
          mentor = MentorProfile.find(params[:id])
          DropOutMentorJob.perform_later(mentor)
          redirect_to admin_profiles_path,
            success: "#{mentor.full_name} is being dropped out of Season #{Season.current.year}"
        end
      end
    end
  end
end
