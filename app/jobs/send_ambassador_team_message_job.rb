class SendAmbassadorTeamMessageJob < ActiveJob::Base
  queue_as :default

  def perform(message_id)
    message = Message.undelivered.find(message_id)

    message.recipient.members.each do |member|
      MessageMailer.send_message(message, member).deliver_now
    end

    message.delivered!
  end
end
