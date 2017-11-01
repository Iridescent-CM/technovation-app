module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :unauthorized!, if: -> {
      not current_session.authenticated? and
        current_account.authenticated? and
          current_account.send("#{current_scope}_profile").nil?
    }

    before_action :unauthenticated!, if: -> {
      not !!params.fetch(:mailer_token) { false } and
        not current_session.authenticated? and
          not current_account.authenticated?
    }

    before_action :attempt_tokenized_signin!, if: -> {
      not current_session.authenticated? and
        not current_account.authenticated? and
          !!params.fetch(:mailer_token) { false }
    }
  end

  private
  def unauthorized!
    redirect_to send(
      "#{current_account.scope_name.sub(/^\w+_r/, "r")}_dashboard_path"
    ),
      error: t("controllers.application.unauthorized") and return
  end

  def attempt_tokenized_signin!
    save_redirected_path

    if account = Account.find_by(mailer_token: params[:mailer_token])
      SignIn.(account, self)
    else
      unauthenticated!
    end
  end

  def unauthenticated!
    save_redirected_path

    redirect_to signin_path,
      notice: t("controllers.application.unauthenticated",
                profile: current_scope.indefinitize.humanize.downcase) and return
  end
end
