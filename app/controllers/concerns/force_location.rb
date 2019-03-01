module ForceLocation
  extend ActiveSupport::Concern

  included do
    before_action :require_location
  end

  private
  def require_location
    return if current_scope == "admin" || current_scope == "regional_ambassador"

    if logged_in_and_has_profile && invalid_location && not_on_location_form
      redirect_to send(
        "#{current_scope}_location_details_path",
        return_to: send("#{current_scope}_dashboard_path")
      ),
        notice: t("controllers.application.invalid_location") and return
    end
  end

  def logged_in_and_has_profile
    current_account.authenticated? &&
      current_account.respond_to?("#{current_scope}_profile") &&
        !!current_account.send("#{current_scope}_profile")
  end

  def invalid_location
    !current_account.valid_address? || !current_account.valid_coordinates?
  end

  def not_on_location_form
    return false if request.xhr?

    begin
      original_request_path = Rails.application.routes.recognize_path(request.original_fullpath)
      location_form_path = Rails.application.routes.recognize_path(
        send("#{current_scope}_location_details_path")
      )

      original_request_path != location_form_path
    rescue ActionController::RoutingError
      return false
    end
  end
end
