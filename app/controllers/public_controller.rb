class PublicController < ApplicationController
  layout "judge"

  # For Airbrake Notifier
  def current_user
    current_account
  end

  def current_scope
    "public"
  end
end
