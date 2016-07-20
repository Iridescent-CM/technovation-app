module RegionalAmbassador
  class SignupsController < ApplicationController
    include Signup

    private
    def model_name
      "regional_ambassador"
    end

    def profile_params
      %i{
          organization_company_name
          ambassador_since_year
        }
    end
  end
end
