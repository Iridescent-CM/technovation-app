class NotifyAmbassadorOfJudgeJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, judge_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    judge = JudgeProfile.find(judge_id)

    if options[:ra_added]
      AmbassadorMailer.confirm_judge_added(
        event.regional_ambassador_profile.account,
        event,
        judge
      ).deliver_now
    else
      AmbassadorMailer.judge_joined_event(
        event.regional_ambassador_profile.account,
        event,
        judge
      ).deliver_now
    end
  end
end
