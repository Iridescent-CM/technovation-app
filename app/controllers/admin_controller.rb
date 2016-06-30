class AdminController < ApplicationController
  before_filter :authenticate_admin!

  layout 'admin'

  private
  def authenticate_admin!
    FindAuthenticationRole.authenticate(:admin, cookies, failure: -> {
      save_redirected_path && go_to_signin("admin")
    })
  end

  def profile_type
    "admin"
  end
end
