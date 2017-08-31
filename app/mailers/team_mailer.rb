class TeamMailer < ApplicationMailer
  def notify_removed_event(team, member, event)
    @team = team
    @event = event
    @member = member
    @ambassador_name = event.regional_ambassador_profile.full_name
    @ambassador_email = event.regional_ambassador_profile.email

    I18n.with_locale(@member.locale) do
      mail to: @member.email,
        subject: "Your RA has removed #{@team.name} from the regional pitch event: #{@event.name}"
    end
  end

  def notify_added_event(team, member, event)
    @team = team
    @event = event
    @member = member
    @ambassador_name = event.regional_ambassador_profile.full_name
    @ambassador_email = event.regional_ambassador_profile.email

    @event_url = send("#{@member.scope_name}_regional_pitch_event_url", event)

    I18n.with_locale(@member.locale) do
      mail to: @member.email,
        subject: "Your RA has added #{@team.name} to the regional pitch event: #{@event.name}"
    end
  end

  def confirm_left_event(team, member, event)
    @team = team
    @event = event
    @member = member

    I18n.with_locale(@member.locale) do
      mail to: @member.email,
        subject: "#{@team.name} has left the regional pitch event: #{@event.name}"
    end
  end

  def confirm_joined_event(team, member, event)
    @team = team
    @event = event
    @member = member

    @event_url = send("#{@member.scope_name}_regional_pitch_event_url", event)

    I18n.with_locale(@member.locale) do
      mail to: @member.email,
        subject: "#{@team.name} has joined the regional pitch event: #{@event.name}"
    end
  end

  def invite_member(invite)
    @greeting = I18n.translate(
      "team_mailer.invite_member.greeting.student",
      name: invite.team_name
    )

    if !!invite.invitee
      invite_existing_student(invite)
    else
      invite_new_student(invite)
    end

    I18n.with_locale(invite.inviter.locale) do
      mail to: invite.invitee_email, template_name: :invite_member
    end
  end

  def invite_mentor(invite)
    @greeting = I18n.translate(
      "team_mailer.invite_member.greeting.mentor",
      name: invite.team_name
    )

    if invite.invitee.full_access_enabled?
      @url = mentor_mentor_invite_url(invite)
      @intro = I18n.translate("team_mailer.invite_member.intro.complete_profile")
      @link_text = "Review this invitation"
    else
      @url = mentor_dashboard_url
      @intro = I18n.translate("team_mailer.invite_member.intro.incomplete_profile")
      @link_text = "Complete your profile"
    end

    I18n.with_locale(invite.inviter.locale) do
      mail to: invite.invitee_email, template_name: :invite_member
    end
  end

  def join_request(recipient, join_request)
    @first_name = join_request.requestor_first_name
    @role_name = join_request.requestor_scope_name
    @team_name = join_request.team_name
    @extra = I18n.translate(
      "team_mailer.join_request.extra.#{join_request.requestor_scope_name}",
      name: @first_name
    )
    @url = send("#{recipient.scope_name}_team_url", join_request.team)

    I18n.with_locale(recipient.locale) do
      mail to: recipient.email,
          subject: I18n.translate("team_mailer.join_request.subject",
                                  role_name: join_request.requestor_scope_name)
    end
  end

  def mentor_join_request_accepted(join_request)
    join_request_status(:accepted, :mentor, join_request)
  end

  def mentor_join_request_declined(join_request)
    join_request_status(:declined, :mentor, join_request)
  end

  def student_join_request_accepted(join_request)
    join_request_status(:accepted, :student, join_request)
  end

  def student_join_request_declined(join_request)
    join_request_status(:declined, :student, join_request)
  end

  private
  def join_request_status(status, type, join_request)
    @first_name = join_request.requestor_first_name
    @team_name = join_request.team_name
    @role_name = I18n.translate("team_mailer.#{type}_join_request_status.role_name")

    if status == :accepted
      @url = send("#{type}_team_url", join_request.team)
    end

    if status == :declined
      @extra = I18n.translate(
        "team_mailer.#{type}_join_request_status.declined_extra"
      )
      @url = send("new_#{type}_team_search_url")

      if type == :student
        @extra_url = "http://www.technovationchallenge.org/curriculum/buildateam/"
      end
    end

    I18n.with_locale(join_request.requestor.locale) do
      mail to: join_request.requestor_email,
        subject: I18n.translate(
          "team_mailer.#{type}_join_request_status.#{status}_subject",
          name: join_request.team_name
        ),
        template_name: "join_request_#{status}"
    end
  end

  def invite_existing_student(invite)
    @url = student_team_member_invite_url(invite)
    @intro = I18n.translate("team_mailer.invite_member.intro.existing_profile")
    @link_text = "Review this invitation"
  end

  def invite_new_student(invite)
    attempt = SignupAttempt.create!(
      email: invite.invitee_email,
      password: SecureRandom.hex(17),
      status: SignupAttempt.statuses[:temporary_password],
    )

    if token = attempt.activation_token
      @url = student_signup_url(token: token)
      @intro = I18n.translate("team_mailer.invite_member.intro.no_profile")
      @link_text = "Signup to join this team"
    else
      raise TokenNotPresent, "Signup Attempt ID: #{attempt.id}"
    end
  end
end
