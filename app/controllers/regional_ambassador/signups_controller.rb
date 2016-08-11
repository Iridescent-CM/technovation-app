module RegionalAmbassador
  class SignupsController < ApplicationController
    include SignupController

    private
    def model_name
      "regional_ambassador"
    end

    def profile_params
      %i{
          ambassador_since_year
          organization_company_name
          bio
          job_title
        }
    end
  end
end
