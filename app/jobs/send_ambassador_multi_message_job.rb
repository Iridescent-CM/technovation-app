class SendAmbassadorMultiMessageJob < ActiveJob::Base
  queue_as :default

  def perform(message_id)
    message = MultiMessage.undelivered.find(message_id)

    message.teams.flat_map(&:members).each do |member|
      MessageMailer.send_message(message, member).deliver_now
    end

    message.judges.each do |judge|
      MessageMailer.send_message(message, judge).deliver_now
    end

    message.delivered!
  end
end
