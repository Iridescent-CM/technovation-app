class EventMailer < ApplicationMailer
  def notify_removed(removed_klass_name, removed_id, event_id, team_name: "")
    @removed = removed_klass_name.constantize.find(removed_id)
    @event = RegionalPitchEvent.find(event_id)
    @team_name = team_name

    @ambassador_name = @event.ambassador.name
    @ambassador_email = @event.ambassador.email

    subject = %w[Account JudgeProfile UserInvitation].include?(
      removed_klass_name
    ) ?
      "You have been removed from a Technovation event" :
      "Your team has been removed from a Technovation event"

    I18n.with_locale(@removed.locale) do
      mail to: @removed.email, subject: subject
    end
  end

  def invite(invite_klass_name, invite_id, event_id)
    @invite = invite_klass_name.constantize.find(invite_id)
    @event = RegionalPitchEvent.find(event_id)

    @ambassador_name = @event.ambassador.name
    @ambassador_email = @event.ambassador.email

    @url = case @invite.status
    when "sent", "opened"
      signup_url(invite_code: @invite.admin_permission_token)
    when "registered", "past_season", "training", "ready"
      if @invite.scope_name == "student"
        student_dashboard_url(
          mailer_token: @invite.mailer_token,
          anchor: "/events"
        )
      else
        send(
          "#{@invite.scope_name}_dashboard_url",
          mailer_token: @invite.mailer_token
        )
      end
    else
      raise ArgumentError,
        "#{@invite.status} is an unsupported @invite status"
    end

    subject = %w[Account JudgeProfile UserInvitation].include?(
      invite_klass_name
    ) ?
      "You are invited to judge a Technovation Girls event" :
      "Your team is invited to attend a Technovation Girls event"

    I18n.with_locale(@invite.locale) do
      mail to: @invite.email,
        subject: subject
    end
  end
end
