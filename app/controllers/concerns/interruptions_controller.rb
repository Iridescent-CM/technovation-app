module InterruptionController
  extend ActiveSupport::Concern

  def index
    render template: "interruptions/#{params[:issue]}_interruption"
  end
end
