class ParentalConsentsController < ApplicationController
  layout "documents"

  def show
    @parental_consent = authorize ParentalConsent.find(params.fetch(:id))
  end

  def new
    if student.present? and !student.consent_signed?
      redirect_to edit_parental_consent_path(student.parental_consent)
    elsif student.present? and student.consent_signed?
      redirect_to parental_consent_path(student.parental_consent),
        success: t("controllers.parental_consents.create.success")
    else
      redirect_to root_path,
        alert: t("controllers.parental_consents.new.unauthorized")
    end
  end

  def edit
    if student.present? && !student.consent_signed?
      @parental_consent = student.parental_consent || student.create_parental_consent!
      @parental_consent.student_profile_consent_token = params.fetch(:token)
      @parental_consent.newsletter_opt_in = true
    elsif student.present? && student.consent_signed?
      redirect_to parental_consent_path(student.parental_consent),
        success: t("controllers.parental_consents.create.success")
    else
      redirect_to root_path,
        alert: t("controllers.parental_consents.new.unauthorized")
    end
  end

  def update
    token = parental_consent_params[:student_profile_consent_token]

    if student(token: token).present? and student.consent_signed?
      redirect_to parental_consent_path(student.parental_consent),
        success: t("controllers.parental_consents.create.success") and return
    end

    @parental_consent = student.parental_consent

    if @parental_consent.update(parental_consent_params)
      redirect_to edit_media_consent_path(token: token)
    else
      render :edit
    end
  end

  private

  def student(opts = {})
    opts[:token] ||= params.fetch(:token) { "" }
    @student ||= StudentProfile.joins(:account)
      .find_by("accounts.consent_token = ?", opts[:token])
  end

  def parental_consent_params
    params.require(:parental_consent).permit(
      :student_profile_consent_token,
      :electronic_signature,
      :newsletter_opt_in
    ).tap do |tapped|
      tapped[:status] = :signed
    end
  end
end
