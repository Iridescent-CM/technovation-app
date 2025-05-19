module ClubAmbassador
  class ProfilesController < AmbassadorController
    include ProfileController

    layout "club_ambassador_rebrand"

    def profile_params
      [
        :job_title
      ]
    end

    private

    def profile
      current_ambassador
    end

    def edit_profile_path
      edit_club_ambassador_profile_path
    end

    def profile_param_root
      :club_ambassador_profile
    end
  end
end
