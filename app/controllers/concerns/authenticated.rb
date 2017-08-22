module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :unauthorized!, if: -> {
      current_account.authenticated? and
        current_account.send("#{current_scope}_profile").nil?
    }

    before_action :unauthenticated!, if: -> {
      not current_account.authenticated?
    }

    before_action :interrupt!, unless: -> {
      current_account.admin? or
      (%w{interruptions profiles}.include?(controller_name) or
        (current_account.valid? and
          current_account.profile_valid?))
    }
  end

  private
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

  def interrupt!
    redirect_to interruptions_path(issue: :invalid_profile) and return
  end
end
