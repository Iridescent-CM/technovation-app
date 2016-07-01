module Mentor
  class SignupsController < ::SignupsController
    before_filter :expertises

    private
    def model_name
      "mentor"
    end

    def profile_params
      [
        :school_company_name,
        :job_title,
        { expertise_ids: [] },
      ]
    end

    def expertises
      @expertises ||= Expertise.all
    end
  end
end
