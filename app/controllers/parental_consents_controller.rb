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
      if params[:source] == "text_message" && student.parent_guardian_phone_number.present?
        SendSignedConsentTextMessageJob.perform_later(account_id: student.account.id, message_type: :signed_parental_consent)
      elsif student.parent_guardian_email.present?
        ParentMailer.confirm_parental_consent_finished(student.id).deliver_later
      end

      redirect_to edit_media_consent_path(token: token, source: params[:source])
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
      :source,
      :electronic_signature,
      :newsletter_opt_in
    ).tap do |tapped|
      tapped[:status] = :signed
    end
  end
end
