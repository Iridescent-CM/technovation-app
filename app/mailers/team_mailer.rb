class TeamMailer < ApplicationMailer
  def invite_member(invite)
    @greeting = I18n.translate("team_mailer.invite_member.greeting.student", team_name: invite.team_name)

    if invite.invitee && CompletionSteps.new(invite.invitee).unlocked?(new_student_team_search_url)
      @url = student_team_member_invite_url(invite)
      @intro = I18n.translate("team_mailer.invite_member.intro.complete_profile")
    elsif invite.invitee
      @url = student_dashboard_url
      @intro = I18n.translate("team_mailer.invite_member.intro.incomplete_profile")
    else
      @url = student_signup_url(email: invite.invitee_email)
      @intro = I18n.translate("team_mailer.invite_member.intro.no_profile")
    end

    mail to: invite.invitee_email, template_name: :invite_member
  end

  def invite_mentor(invite)
    @greeting = I18n.translate("team_mailer.invite_member.greeting.mentor", team_name: invite.team_name)

    if CompletionSteps.new(invite.invitee).unlocked?(new_mentor_team_search_url)
      @url = mentor_mentor_invite_url(invite)
      @intro = I18n.translate("team_mailer.invite_member.intro.complete_profile")
    else
      @url = mentor_dashboard_url
      @intro = I18n.translate("team_mailer.invite_member.intro.incomplete_profile")
    end

    mail to: invite.invitee_email, template_name: :invite_member
  end

  def join_request(recipient, join_request)
    @requestor_name = join_request.requestor_first_name
    @role_name = join_request.requestor_type_name
    @url = send("#{recipient.type_name}_team_url", join_request.joinable)

    mail to: recipient.email,
        subject: I18n.translate("team_mailer.join_request.subject",
                                role_name: join_request.requestor_type_name)
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
    @intro = I18n.translate("team_mailer.#{type}_join_request_status.#{status}_intro",
                            name: join_request.joinable_name)
    if status == :accepted
      @url = send("#{type}_team_url", join_request.joinable)
    end

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.#{type}_join_request_status.#{status}_subject",
                              name: join_request.joinable_name),
      template_name: :join_request_status
  end
end
