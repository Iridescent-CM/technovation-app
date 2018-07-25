class RegistrationController < ActionController::API
  include CookiesHelper

  private
  def cookies
    request.cookie_jar
  end
end