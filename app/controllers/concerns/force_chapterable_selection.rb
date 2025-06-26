module ForceChapterableSelection
  extend ActiveSupport::Concern

  included do
    before_action :require_chapterable_selection
  end

  private

  def require_chapterable_selection
    return if request.xhr? ||
      !logged_in_and_has_profile? ||
      !valid_location? ||
      !current_account.force_chapterable_selection? &&
        (
          current_account.assigned_to_chapterable? ||
          current_account.no_chapterable_selected? ||
          current_account.no_chapterables_available?
        ) ||
      (current_account.scope_name != "student" && current_account.scope_name != "mentor") ||
      on_chapter_selection_page?

    redirect_to new_chapterable_account_assignments_path
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

    chapter_selection_path = Rails.application.routes.recognize_path(
      new_chapterable_account_assignments_path
    )

    original_request_path == chapter_selection_path
  end
end
