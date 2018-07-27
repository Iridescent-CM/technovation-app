class RegistrationController < ActionController::API
  include CookiesHelper

  private
  def cookies
    request.cookie_jar
  end

  def current_scope
    'registration'
  end
end