class SignedConsentsController < ApplicationController
  layout "documents"

  def show
    @account = Account.find_by(consent_token: params[:token])

    if @account.blank?
      redirect_to root_path, alert: t("controllers.parental_consents.new.unauthorized")
    else
      @student_profile = @account.student_profile
      @parental_consent = @student_profile.parental_consent
      @media_consent = @student_profile.media_consent
    end
  end
end
