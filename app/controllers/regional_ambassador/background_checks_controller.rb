module RegionalAmbassador
  class BackgroundChecksController < RegionalAmbassadorController
    include BackgroundCheckController

    private
    def current_account
      current_ambassador
    end
  end
end
