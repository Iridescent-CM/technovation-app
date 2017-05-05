module RegionalAmbassador
  class BackgroundChecksController < RegionalAmbassadorController
    include BackgroundCheckController
    private
    def current_profile
      current_ambassador
    end
  end
end
