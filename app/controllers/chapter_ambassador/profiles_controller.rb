module ChapterAmbassador
  class ProfilesController < ChapterAmbassadorController
    include ProfileController

    layout "chapter_ambassador_rebrand"

    def profile_params
      [
        :job_title,
        :organization_status,
        :phone_number
      ]
    end

    private

    def profile
      current_ambassador
    end

    def edit_profile_path
      edit_chapter_ambassador_profile_path
    end

    def profile_param_root
      :chapter_ambassador_profile
    end
  end
end
