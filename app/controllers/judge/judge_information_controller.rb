module Judge
  class JudgeInformationController < JudgeController
    def edit
    end
    
    def update
      if current_judge.update(judge_information_params)
        redirect_to judge_dashboard_path, success: "Judge information updated successfully."
      else
        render :edit
      end
    end

    private

    def judge_information_params
      params.require(:judge_profile).permit(
        :technical_experience_opt_in,
        :ai_experience,
        technical_skill_ids: []
      )
    end
  end
end
