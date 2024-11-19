module Admin::Clubs
  class LocationsController < AdminController
    def edit
      @club = Club.find(params[:club_id])
    end
  end
end
