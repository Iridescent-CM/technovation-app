module ForceTermsAgreement
  extend ActiveSupport::Concern

  included do
    before_action :require_terms_agreement
  end

  private
  def require_terms_agreement
    return if ajax_request

    return if current_scope == "admin" || current_scope == "regional_ambassador"

    if logged_in_and_has_profile && !current_account.terms_agreed? && !on_data_agreement_form
      redirect_to edit_terms_agreement_path,
        notice: t("controllers.application.no_data_agreement_on_file") and return
    end
  end

  def logged_in_and_has_profile
    current_account.authenticated? &&
      current_account.respond_to?("#{current_scope}_profile") &&
        !!current_account.send("#{current_scope}_profile")
  end

  def on_data_agreement_form
    original_request_path = Rails.application.routes.recognize_path(
      request.fullpath,
      method: request.method
    )

    data_agreement_form_path = Rails.application.routes.recognize_path(
      edit_terms_agreement_path
    )

    original_request_path == data_agreement_form_path
  end

  def ajax_request
    request.xhr? || request.xml_http_request?
  end
end
