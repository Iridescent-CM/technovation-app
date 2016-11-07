class InterruptionsController < ApplicationController
  def index
    # load .errors
    current_account.valid?
    current_account.profile_valid?

    render template: "interruptions/#{params[:issue]}_interruption"
  end
end
