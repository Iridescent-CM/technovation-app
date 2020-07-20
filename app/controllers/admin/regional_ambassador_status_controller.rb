module Admin
  class RegionalAmbassadorStatusController < AdminController
    def update
      @regional_ambassador_profile = RegionalAmbassadorProfile.find(params[:id])
      @regional_ambassador_profile.update(regional_ambassador_status_params)
      redirect_to admin_participant_path(@regional_ambassador_profile.account),
        success: "You set this Chapter Ambassador to #{@regional_ambassador_profile.status}"
    end

    private
    def regional_ambassador_status_params
      params.require(:regional_ambassador_profile).permit(:status)
    end
  end
end
