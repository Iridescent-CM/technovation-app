class SendAmbassadorJudgeMessageJob < ActiveJob::Base
  queue_as :default

  def perform(message_id)
    message = Message.undelivered.find(message_id)

    MessageMailer.send_message(message).deliver_now

    message.delivered!
  end
end
