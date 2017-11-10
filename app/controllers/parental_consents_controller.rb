class ParentalConsentsController < ApplicationController
  def show
    @parental_consent = ParentalConsent.find(params.fetch(:id))
  end

  def new
    if student.present? and not student.consent_signed?
      @parental_consent = ParentalConsent.new(
        student_profile_consent_token: params.fetch(:token),
        newsletter_opt_in: true,
      )
    elsif student.present? and student.consent_signed?
      redirect_to parental_consent_path(student.parental_consent),
        success: t("controllers.parental_consents.create.success")
    else
      redirect_to application_dashboard_path,
        alert: t("controllers.parental_consents.new.unauthorized")
    end
  end

  def create
    token = parental_consent_params[:student_profile_consent_token]
    if student(token: token).present? and student.consent_signed?
      redirect_to parental_consent_path(student.parental_consent),
        success: t("controllers.parental_consents.create.success") and return
    end

    @parental_consent = ParentalConsent.new(parental_consent_params)

    if @parental_consent.save
      redirect_to parental_consent_path(@parental_consent),
        success: t("controllers.parental_consents.create.success")
    else
      render :new
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
      :newsletter_opt_in,
    )
  end
end
