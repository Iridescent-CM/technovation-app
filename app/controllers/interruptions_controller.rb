class InterruptionsController < ApplicationController
  def index
    render template: "interruptions/#{params[:issue]}_interruption"
  end
end
