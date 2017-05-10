module Legacy
  module V2
    module RegionalAmbassador
      class MessageDeliveriesController < RegionalAmbassadorController
        def create
          @message = current_ambassador
            .public_send(params.fetch(:message_type).underscore.pluralize)
            .unsent.find(params.fetch(:message_id))

          if params[:message_type] == "MultiMessage"
            SendAmbassadorMultiMessageJob.perform_later(@message.id)
          elsif @message.recipient_type == "Team"
            SendAmbassadorTeamMessageJob.perform_later(@message.id)
          else
            SendAmbassadorJudgeMessageJob.perform_later(@message.id)
          end

          @message.sent!
          redirect_back fallback_location: regional_ambassador_dashboard_path,
            success: "Your message has been sent!"
        end
      end
    end
  end
end
