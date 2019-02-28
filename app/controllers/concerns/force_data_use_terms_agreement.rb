module ForceDataUseTermsAgreement
  extend ActiveSupport::Concern

  included do
    before_action :require_data_use_terms
  end

  private
  def require_data_use_terms
    return if current_scope == "admin" || current_scope == "regional_ambassador"

    if logged_in_and_has_profile && no_data_agreement && not_on_data_agreement_form
      redirect_to account_data_data_use_terms_edit_path,
        notice: t("controllers.application.no_data_agreement_on_file") and return
    end
  end

  def logged_in_and_has_profile
    current_account.authenticated? &&
      current_account.respond_to?("#{current_scope}_profile") &&
        !!current_account.send("#{current_scope}_profile")
  end

  def no_data_agreement
    !current_account.terms_agreed?
  end

  def not_on_data_agreement_form
    return false if request.xhr?

    original_request_path = Rails.application.routes.recognize_path(request.original_fullpath)
    data_agreement_form_path = Rails.application.routes.recognize_path(
      account_data_data_use_terms_edit_path
    )

    original_request_path != data_agreement_form_path
  end
end
