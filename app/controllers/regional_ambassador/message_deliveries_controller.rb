module RegionalAmbassador
  class MessageDeliveriesController < RegionalAmbassadorController
    def create
      @message = current_ambassador.messages.unsent.find(params.fetch(:message_id))
      SendAmbassadorTeamMessageJob.perform_later(@message.id)
      @message.sent!
      redirect_to :back, success: "Your message has been sent!"
    end
  end
end
