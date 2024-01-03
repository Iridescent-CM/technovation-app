class JudgeMailer < ApplicationMailer
  def confirm_left_event(judge, event)
    @judge = judge
    @event = event

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "You have left the regional pitch event: #{@event.name}"
    end
  end

  def confirm_joined_event(judge, event)
    @judge = judge
    @event = event

    @event_url = judge_regional_pitch_event_url(event)

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "You have joined the regional pitch event: #{@event.name}"
    end
  end

  def notify_removed_event(judge, event)
    notify_removed_from_event(judge.id, event.id)
  end

  def notify_removed_from_event(judge_id, event_id)
    @judge = JudgeProfile.find(judge_id).account
    @event = RegionalPitchEvent.find(event_id)

    @ambassador_name = @event.ambassador.name
    @ambassador_email = @event.ambassador.email

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "You have been removed from a Technovation event: #{@event.name}"
    end
  end

  def notify_added_event(judge, event)
    invite_to_event(judge.id, event.id)
  end

  def invite_to_event(judge_id, event_id)
    @judge = JudgeProfile.find(judge_id).account
    @event = RegionalPitchEvent.find(event_id)

    @ambassador_name = @event.ambassador.name
    @ambassador_email = @event.ambassador.email

    @event_url = judge_regional_pitch_event_url(@event)

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "You are invited to judge a Technovation event: " +
          @event.name
    end
  end
end
