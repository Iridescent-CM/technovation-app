class MediaConsentsController < ApplicationController
  layout "documents"

  def show
    @media_consent = find_media_consent
    @parental_consent = find_parental_consent

    if @media_consent.blank?
      redirect_to root_path, alert: t("controllers.media_consents.invalid")
    end
  end

  def edit
    @media_consent = find_media_consent
    @parental_consent = find_parental_consent

    if @media_consent.blank?
      redirect_to root_path, alert: t("controllers.media_consents.invalid")
    elsif @media_consent.signed?
      redirect_to action: :show, token: params.fetch(:token)
    end
  end

  def update
    @media_consent = find_media_consent
    @parental_consent = find_parental_consent

    if @media_consent.update(media_consent_params.merge(signed_at: Time.current))
      redirect_to(
        {
          action: :show,
          token: params.fetch(:token)
        },
        success: t("controllers.media_consents.update.success")
      )
    else
      render :edit
    end
  end

  private

  def find_media_consent
    student_profile&.media_consent
  end

  def find_parental_consent
    student_profile&.parental_consent
  end

  def student_profile
    @student_profile ||= Account.find_by(consent_token: params.fetch(:token))
      &.student_profile
  end

  def media_consent_params
    params.require(:media_consent).permit(
      :electronic_signature,
      :consent_provided
    )
  end
end
