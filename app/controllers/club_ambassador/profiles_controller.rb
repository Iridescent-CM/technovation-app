module ClubAmbassador
  class ProfilesController < ClubAmbassadorController
    include ProfileController

    def profile_params
      [
        :job_title
      ]
    end

    private

    def profile
      current_club_ambassador
    end

    def edit_profile_path
      edit_club_ambassador_profile_path
    end

    def profile_param_root
      :club_ambassador_profile
    end
  end
end