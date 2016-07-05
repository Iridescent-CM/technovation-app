module Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate!
    helper_method :current_account
  end

  private
  def authenticate!
    FindAccount.authenticate(model_name, cookies, failure: -> {
      save_redirected_path
      go_to_signin(model_name)
    })
  end

  def current_account
    @current_account ||= FindAccount.current(model_name, cookies)
  end

  def model_name
    self.class.name.deconstantize.split('::')[0].underscore
  end
end
