module Admin
  class BackgroundCheckExemptionsController < AdminController
    def grant
      @account = Account.find(params[:participant_id])

      if @account.grant_background_check_exemption!
        redirect_to admin_participant_path(@account),
          success: "Background check exemption granted"
      else
        redirect_to admin_participant_path(@account),
          error: "Error granting background check exemption"
      end
    end

    def revoke
      @account = Account.find(params[:participant_id])

      if @account.revoke_background_check_exemption!
        redirect_to admin_participant_path(@account),
          success: "Background check exemption revoked"
      else
        redirect_to admin_participant_path(@account),
          error: "Error revoking background check exemption"
      end
    end
  end
end
