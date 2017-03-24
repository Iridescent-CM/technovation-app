class NotifyJudgeOfLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, judge_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    judge = JudgeProfile.find(judge_id)

    if options[:ra_removed]
      JudgeMailer.notify_removed_event(judge, event).deliver_now
    else
      JudgeMailer.confirm_left_event(judge, event).deliver_now
    end
  end
end
