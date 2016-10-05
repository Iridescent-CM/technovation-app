module Judge
  class SignupsController < ApplicationController
    include SignupController

    private
    def model_name
      "judge"
    end

    def profile_params
      [
        :company_name,
        :job_title,
      ]
    end
  end
end
