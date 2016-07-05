class AdminController < ApplicationController
  before_filter :authenticate_admin!

  layout 'admin'

  private
  def authenticate_admin!
    FindAccount.authenticate(:admin, cookies, failure: -> {
      save_redirected_path && go_to_signin("admin")
    })
  end
end
