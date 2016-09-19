class SignupsController < ApplicationController
  before_action :require_unauthenticated

  def new
    if (request.referer || "").downcase.match(/technovationchallenge.org\/madewithcode/)
      cookies.permanent[:made_with_code] = true
    end
  end
end
