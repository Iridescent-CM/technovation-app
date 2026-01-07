class AssignJudgesToRegionalPitchEventJob < ActiveJob::Base
  queue_as :default

  def perform(regional_pitch_event_id:, judge_ids:, account_id:)
    regional_pitch_event = RegionalPitchEvent.find(regional_pitch_event_id)
    account = Account.find(account_id)
    assignment_result = DataProcessors::AssignJudgesToRegionalPitchEvent.new(regional_pitch_event:, judge_ids:).call

    AmbassadorMailer.assigned_judges_to_event(
      event: regional_pitch_event,
      account:,
      assignment_result:
    ).deliver_now
  end
end
