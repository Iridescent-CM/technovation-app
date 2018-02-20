class EventMailer < ApplicationMailer
  def notify_removed(removed_klass_name, removed_id, event_id)
    @removed = removed_klass_name.constantize.find(removed_id)
    @event = RegionalPitchEvent.find(event_id)

    @ambassador_name = @event.regional_ambassador_profile.full_name
    @ambassador_email = @event.regional_ambassador_profile.email

    I18n.with_locale(@removed.locale) do
      mail to: @removed.email,
        subject: "You have been removed from a Technovation event: #{@event.name}"
    end
  end

  def invite(invite_klass_name, invite_id, event_id)
    @invite = invite_klass_name.constantize.find(invite_id)
    @event = RegionalPitchEvent.find(event_id)

    @ambassador_name = @event.regional_ambassador_profile.full_name
    @ambassador_email = @event.regional_ambassador_profile.email

    @url = case @invite.status
           when "sent", "opened"
             judge_signup_url(
               admin_permission_token: @invite.admin_permission_token
             )
           when "registered", "past_season", "training", "ready"
             judge_dashboard_url(
               mailer_token: @invite.mailer_token
             )
           else
             raise ArgumentError,
               "#{@invite.status} is an unsupported @invite status"
           end


    I18n.with_locale(@invite.locale) do
      mail to: @invite.email,
        subject: "You are invited to participate in a Technovation event: " +
                 @event.name
    end
  end
end
