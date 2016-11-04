class RegionalAmbassadorController < ApplicationController
  include Authenticated

  layout "regional_ambassador"
  helper_method :current_ambassador

  private
  def current_ambassador
    @current_ambassador ||= Account.joins(:regional_ambassador_profile).find_by(auth_token: (cookies.fetch(:auth_token)))
  end
end
