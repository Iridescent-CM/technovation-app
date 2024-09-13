module ForceChapterSelection
  extend ActiveSupport::Concern

  included do
    before_action :require_chapter_selection
  end

  private

  def require_chapter_selection
    return if request.xhr? ||
      !logged_in_and_has_profile? ||
      !valid_location? ||
      current_account.assigned_to_chapter? ||
      current_account.scope_name != "student" ||
      on_chapter_selection_page?

    redirect_to chapter_selection_path
  end

  def logged_in_and_has_profile?
    current_account.authenticated? &&
      current_account.respond_to?(:"#{current_scope}_profile") &&
      !!current_account.send(:"#{current_scope}_profile")
  end

  def valid_location?
    current_account.valid_address? && current_account.valid_coordinates?
  end

  def on_chapter_selection_page?
    original_request_path = Rails.application.routes.recognize_path(
      request.fullpath,
      method: request.method
    )

    path_for_chapter_selction = Rails.application.routes.recognize_path(
      chapter_selection_path
    )

    original_request_path == path_for_chapter_selction
  end
end
