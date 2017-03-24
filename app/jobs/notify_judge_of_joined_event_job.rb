class NotifyJudgeOfJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, judge_id, options = {})
    event = RegionalPitchEvent.find(event_id)
    judge = JudgeProfile.find(judge_id)

    return unless event.live?

    if options[:ra_added]
      JudgeMailer.notify_added_event(judge, event).deliver_now
    else
      JudgeMailer.confirm_joined_event(judge, event).deliver_now
    end
  end
end
