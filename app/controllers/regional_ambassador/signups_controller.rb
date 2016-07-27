module RegionalAmbassador
  class SignupsController < ApplicationController
    include Signup

    private
    def model_name
      "regional_ambassador"
    end

    def profile_params
      %i{
          ambassador_since_year
          organization_company_name
          job_title
        }
    end
  end
end
