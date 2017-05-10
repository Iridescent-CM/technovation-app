module Legacy
  module V2
    module Admin
      class TeamLocationsController < AdminController
        def edit
          @team = Team.find(params[:id])
        end
      end
    end
  end
end
