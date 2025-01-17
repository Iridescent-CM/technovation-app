module ClubAmbassador
  class ClubHeadquartersLocationsController < AmbassadorController
    layout "club_ambassador_rebrand"

    def update
      @club = current_ambassador.club
      if @club.update(club_headquarters_location_params)
        redirect_to club_ambassador_club_location_path,
          success: "You updated your club headquarters location details!"
      else
        flash.now[:alert] = "Error updating club headquarters location details."
        render :edit
      end
    end

    private

    def club_headquarters_location_params
      params.require(:club).permit(
        :headquarters_location
      )
    end
  end
end
