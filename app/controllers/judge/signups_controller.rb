module Judge
  class SignupsController < ApplicationController
    include SignupController

    before_filter :scoring_expertises

    private
    def model_name
      "judge"
    end

    def profile_params
      [
        :company_name,
        :job_title,
        { scoring_expertise_ids: [] },
      ]
    end

    def scoring_expertises
      @scoring_expertises ||= ScoreCategory.is_expertise
    end
  end
end
