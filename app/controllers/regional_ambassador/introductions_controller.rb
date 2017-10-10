module RegionalAmbassador
  class IntroductionsController < RegionalAmbassadorController
    def update
      if ProfileUpdating.execute(current_ambassador, nil, introduction_params)
        redirect_to regional_ambassador_dashboard_path,
          success: "You updated your introduction!"
      else
        render :edit
      end
    end

    private
    def introduction_params
      params.require(:regional_ambassador_profile).permit(
        :intro_summary,
        links: [:type, :value],
      )
    end
  end
end
