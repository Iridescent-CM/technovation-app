module Judge
  class ConsentWaiversController < JudgeController
    def new
      @consent_waiver = current_account.build_consent_waiver(
        account_consent_token: current_account.consent_token,
      )

      render "consent_waivers/new"
    end

    def create
      @consent_waiver = current_account.build_consent_waiver(
       consent_waiver_params
      )

      if @consent_waiver.save
        redirect_to judge_dashboard_path,
          success: t("controllers.consent_waivers.create.success")
      else
        render "consent_waivers/new"
      end
    end

    def show
      @consent_waiver = current_account.consent_waiver
      render "consent_waivers/show"
    end

    private
    def consent_waiver_params
      params.require(:consent_waiver).permit(
        :account_consent_token,
        :electronic_signature
      )
    end
  end
end
