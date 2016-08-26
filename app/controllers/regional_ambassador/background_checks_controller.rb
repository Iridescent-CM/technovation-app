module RegionalAmbassador
  class BackgroundChecksController < RegionalAmbassadorController
    include BackgroundCheckController

    private
    def current_account
      current_ambassador
    end

    def current_profile
      current_ambassador.regional_ambassador_profile
    end
  end
end
