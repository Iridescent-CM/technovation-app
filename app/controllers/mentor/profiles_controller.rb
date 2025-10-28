module Mentor
  class ProfilesController < MentorController
    include ProfileController

    before_action :expertises, :mentor_types

    def profile_params
      [
        :id,
        :school_company_name,
        :job_title,
        :bio,
        :accepting_team_invites,
        :virtual,
        :connect_with_mentors,
        {
          expertise_ids: [],
          mentor_type_ids: []
        }
      ]
    end

    private

    def profile
      current_mentor
    end

    def expertises
      @expertises ||= Expertise.all
    end

    def mentor_types
      @mentor_types ||= MentorType.all
    end

    def edit_profile_path
      edit_mentor_profile_path
    end

    def profile_param_root
      :mentor_profile
    end
  end
end
