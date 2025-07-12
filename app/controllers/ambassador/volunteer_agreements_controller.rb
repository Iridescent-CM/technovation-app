module Ambassador
  class VolunteerAgreementsController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded
    layout :set_layout_for_current_ambassador

    def new
      @volunteer_agreement = VolunteerAgreement.new
    end

    def create
      @volunteer_agreement = current_ambassador.build_volunteer_agreement(volunteer_agreement_params)

      if @volunteer_agreement.save
        redirect_to club_ambassador_volunteer_agreement_path,
          success: "Thank you for signing #{current_scope.titleize} the Volunteer Agreement"
      else
        flash.now[:error] = "Error signing agreement"
        render :new
      end
    end

    private

    def volunteer_agreement_params
      params.require(:volunteer_agreement).permit(
        :electronic_signature
      )
    end
  end
end
