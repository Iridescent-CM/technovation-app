class NotifyAmbassadorOfJudgeLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, judge_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    judge = JudgeProfile.find(judge_id)

    if options[:ra_removed]
      AmbassadorMailer.confirm_judge_removed(
        event.regional_ambassador_profile.account,
        event,
        judge
      ).deliver_now
    else
      AmbassadorMailer.judge_left_event(
        event.regional_ambassador_profile.account,
        event,
        judge
      ).deliver_now
    end
  end
end
