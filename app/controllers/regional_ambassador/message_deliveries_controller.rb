module RegionalAmbassador
  class MessageDeliveriesController < RegionalAmbassadorController
    def create
      @message = current_ambassador.messages.unsent.find(params.fetch(:message_id))

      if @message.recipient_type == "Team"
        SendAmbassadorTeamMessageJob.perform_later(@message.id)
      else
        SendAmbassadorJudgeMessageJob.perform_later(@message.id)
      end

      @message.sent!
      redirect_to :back, success: "Your message has been sent!"
    end
  end
end
