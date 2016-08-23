module Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate!
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
