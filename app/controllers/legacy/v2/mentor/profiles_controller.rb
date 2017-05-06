module Legacy
  module V2
    module Mentor
      class ProfilesController < MentorController
        include ProfileController

        before_action :expertises

        def profile_params
          [
            :school_company_name,
            :job_title,
            :bio,
            :accepting_team_invites,
            :virtual,
            :connect_with_mentors,
            { expertise_ids: [] },
          ]
        end

        private
        def account
          current_mentor
        end

        def expertises
          @expertises ||= Expertise.all
        end

        def edit_profile_path
          edit_mentor_profile_path
        end

        def account_param_root
          :mentor_profile
        end
      end
    end
  end
end
