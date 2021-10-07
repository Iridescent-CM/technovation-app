class NewRegistrationController < ApplicationController
  layout "new_registration"
  def show
  end

  def create
    puts params.inspect
    Rails.logger.debug params.inspect
    #some logic
  end
end
