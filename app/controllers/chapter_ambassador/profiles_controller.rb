module ChapterAmbassador
  class ProfilesController < ChapterAmbassadorController
    include ProfileController

    layout "chapter_ambassador_dashboard"

    def profile_params
      [
        :organization_company_name,
        :job_title,
        :bio
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
