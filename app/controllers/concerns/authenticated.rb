module Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate!

    before_action -> {
      redirect_to interruptions_path(issue: :invalid_profile) and return
    }, unless: -> {
      current_account.admin? or
      (%w{interruptions profiles}.include?(controller_name) or
        (current_account.valid? and
          current_account.profile_valid?))
    }
  end

  private
  def authenticate!
    token = cookies.fetch(:auth_token) { "" }
    account = Account.find_by(auth_token: token)

    if account && account.send("#{model_name}_profile")
      true
    elsif account
      redirect_to send("#{type_name}_dashboard_path"),
        alert: t("controllers.application.unauthorized")
    else
      save_redirected_path
      go_to_signin(model_name)
    end
  end
end
