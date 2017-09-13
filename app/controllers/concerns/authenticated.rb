module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :unauthorized!, if: -> {
      current_account.authenticated? and
        current_account.send("#{current_scope}_profile").nil? and
          not authenticated_exceptions.include?("#{controller_name}##{action_name}")
    }

    before_action :unauthenticated!, if: -> {
      not current_account.authenticated? and
        not authenticated_exceptions.include?("#{controller_name}##{action_name}")
    }
  end

  private
  def authenticated_exceptions
    []
  end

  def unauthorized!
    redirect_to send("#{current_account.scope_name}_dashboard_path"),
      error: t("controllers.application.unauthorized") and return
  end

  def unauthenticated!
    save_redirected_path

    redirect_to signin_path,
      notice: t("controllers.application.unauthenticated",
                profile: current_scope.indefinitize.humanize.downcase) and return
  end
end
