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
    model_name = self.class.name.deconstantize.split('::')[0].underscore

    account = "#{model_name}_profile".camelize.constantize.joins(:account)
      .references(:accounts)
      .where("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" })
      .first

    unless account.authenticated?
      save_redirected_path
      go_to_signin(model_name)
    end
  end
end
