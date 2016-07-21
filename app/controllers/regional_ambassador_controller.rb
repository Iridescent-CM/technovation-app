class RegionalAmbassadorController < ApplicationController
  include Authenticated

  helper_method :current_ambassador

  private
  def current_ambassador
    @current_ambassador ||= RegionalAmbassadorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end
end
