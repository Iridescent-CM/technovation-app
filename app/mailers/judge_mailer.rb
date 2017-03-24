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

end
