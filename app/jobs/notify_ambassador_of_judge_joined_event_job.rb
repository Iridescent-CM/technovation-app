class NotifyAmbassadorOfJudgeJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, judge_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    judge = JudgeProfile.find(judge_id)

    if options[:chapter_ambassador_added]
      AmbassadorMailer.confirm_judge_added(
        event.ambassador.account,
        event,
        judge
      ).deliver_now
    else
      AmbassadorMailer.judge_joined_event(
        event.ambassador.account,
        event,
        judge
      ).deliver_now
    end
  end
end
