module Mentor
  class SignupsController < ApplicationController
    include Signup
    before_filter :expertises

    private
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

    def model_name
      "mentor"
    end
  end
end
