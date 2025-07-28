module ConsentWaiverController
  extend ActiveSupport::Concern

  def new
    if valid_token?
      @consent_waiver = ConsentWaiver.new(
        account_consent_token: params.fetch(:token)
      )
    else
      redirect_to public_dashboard_path,
        alert: t("controllers.consent_waivers.new.unauthorized")
    end
  end

  def create
    @consent_waiver = ConsentWaiver.new(consent_waiver_params)

    scope = get_cookie(CookieNames::LAST_PROFILE_USED) ||
      @consent_waiver.account_scope_name

    if params[:read_and_understands_code_of_conduct].present? &&
        params[:acknowledges_consequences_of_code_of_conduct].present? &&
        @consent_waiver.save
      redirect_to send(:"#{scope}_dashboard_path"),
        success: t("controllers.consent_waivers.create.success")
    else
      if params[:read_and_understands_code_of_conduct].blank? ||
          params[:acknowledges_consequences_of_code_of_conduct].blank?

        flash.now[:error] = t("controllers.consent_waivers.create.missing_code_of_conduct_acknowledgement_error")
      end
      render :new
    end
  end

  private

  def valid_token?
    Account.exists?(consent_token: params.fetch(:token) { "" })
  end

  def consent_waiver_params
    params.require(:consent_waiver).permit(
      :account_consent_token,
      :electronic_signature
    )
  end
end
