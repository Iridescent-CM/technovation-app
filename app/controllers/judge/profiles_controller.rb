module Judge
  class ProfilesController < JudgeController
    include ProfileController

    def profile_params
      [
        :company_name,
        :job_title,
      ]
    end

    private
    def profile
      current_judge
    end

    def edit_profile_path
      edit_judge_profile_path
    end

    def profile_param_root
      :judge_profile
    end
  end
end
