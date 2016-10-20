module InterruptionController
  extend ActiveSupport::Concerns

  def index
    render template: "interruptions/#{params[:issue]}_interruption"
  end
end
