module RegionalAmbassador
  class MissingParticipantLocationsController < RegionalAmbassadorController
    def edit
      @account = Account.find(params[:id])

      @account.city = nil

      if current_ambassador.country == "US"
        @account.state_province = current_ambassador.state_province
      end

      @account.country = current_ambassador.country
    end

    def update
      @account = Account.find(params[:id])

      if @account.update(location_params)
        Geocoding.perform(@account).with_save
        redirect_to regional_ambassador_participant_path(@account),
          success: "You fixed the location!"
      else
        render :edit
      end
    end

    private
    def location_params
      params.require(:account).permit(
        :city,
        :state_province,
      ).tap do |tapped|
        if current_ambassador.country == "US"
          tapped[:state_province] = current_ambassador.state_province
        end

        tapped[:country] = current_ambassador.country
      end
    end
  end
end
