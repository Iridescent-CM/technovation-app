module Admin
  class TeamLocationsController < AdminController
    def edit
      @team = Team.find(params[:id])
    end
  end
end
