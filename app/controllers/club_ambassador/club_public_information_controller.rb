module ClubAmbassador
  class ClubPublicInformationController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "club_ambassador_rebrand"

    def edit
    end

    def update
      @club = current_ambassador.club
      if @club.update(public_information_params)
        redirect_to club_ambassador_public_information_path,
          success: "You updated your club public information!"
      else
        flash.now[:alert] = "Error updating club details."
        render :edit
      end
    end

    private

    def public_information_params
      params.require(:club).permit(
        :name,
        :summary,
        :primary_account_id,
        :visible_on_map
      )
    end
  end
end
