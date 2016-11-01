module Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate!

    before_action -> {
      unless current_account.valid?
        redirect_to interruptions_path(issue: :invalid_profile) and return
      end
    }, unless: -> {
      %w{interruptions accounts}.include?(controller_name)
    }
  end

  private
  def authenticate!
    FindAccount.authenticate(model_name, cookies,
      unauthenticated: -> {
        save_redirected_path
        go_to_signin(model_name)
      },
      unauthorized: ->(type_name) {
        redirect_to send("#{type_name}_dashboard_path"),
                    alert: t("controllers.application.unauthorized")
      }
    )
  end

  def model_name
    self.class.name.deconstantize.split('::')[0].underscore
  end
end
