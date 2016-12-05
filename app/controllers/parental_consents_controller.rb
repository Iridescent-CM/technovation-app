class ParentalConsentsController < ApplicationController
  def show
    @parental_consent = ParentalConsent.find(params.fetch(:id))
  end

  def new
    if valid_token?
      @parental_consent = ParentalConsent.new(
        student_profile_consent_token: params.fetch(:token),
        newsletter_opt_in: true,
      )
    else
      redirect_to application_dashboard_path,
                  alert: t("controllers.parental_consents.new.unauthorized")
    end
  end

  def create
    @parental_consent = ParentalConsent.new(parental_consent_params)

    if @parental_consent.save
      redirect_to parental_consent_path(@parental_consent),
                  success: t("controllers.parental_consents.create.success")
    else
      render :new
    end
  end

  private
  def valid_token?
    Account.joins(:student_profile).exists?(consent_token: params.fetch(:token) { "" })
  end

  def parental_consent_params
    params.require(:parental_consent).permit(
      :student_profile_consent_token,
      :electronic_signature,
      :newsletter_opt_in,
    )
  end
end
