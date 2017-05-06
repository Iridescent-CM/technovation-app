module Legacy
  module V2
    module RegionalAmbassador
      class BackgroundChecksController < RegionalAmbassadorController
        include Concerns::BackgroundCheckController

        private
        def current_profile
          current_ambassador
        end
      end
    end
  end
end
