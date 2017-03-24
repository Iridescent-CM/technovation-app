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
    @judge = judge
    @event = event
    @ambassador_name = event.regional_ambassador_profile.full_name
    @ambassador_email = event.regional_ambassador_profile.email

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "Your RA has removed you from the regional pitch event: #{@event.name}"
    end
  end

  def notify_added_event(judge, event)
    @judge = judge
    @event = event
    @ambassador_name = event.regional_ambassador_profile.full_name
    @ambassador_email = event.regional_ambassador_profile.email

    @event_url = judge_regional_pitch_event_url(event)

    I18n.with_locale(@judge.locale) do
      mail to: @judge.email,
        subject: "Your RA has added you to the regional pitch event: #{@event.name}"
    end
  end
end
