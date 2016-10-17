class SignupsController < ApplicationController
  before_action :require_unauthenticated

  def new
    unless cookies[:signup_token].present?
      redirect_to root_path
    end
  end
end
