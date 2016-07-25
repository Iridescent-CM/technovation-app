class TeamMailer < ApplicationMailer
  def invite_member(team_member_invite)
    @url = team_member_invite_url(team_member_invite)

    mail to: team_member_invite.invitee_email
  end

  def invite_mentor(mentor_invite)
    @url = mentor_mentor_invite_url(mentor_invite)

    mail to: mentor_invite.invitee_email,
         template_name: :invite_member
  end

  def join_request(join_request)
    @url = student_team_url(join_request.joinable)
    @requestor_name = join_request.requestor_full_name
    @role_name = join_request.requestor_type_name

    mail to: join_request.joinable.student_emails,
      subject: I18n.translate("team_mailer.join_request.subject",
                              role_name: join_request.requestor_type_name)
  end

  def mentor_join_request_accepted(join_request)
    @intro = I18n.translate("team_mailer.mentor_join_request_status.accepted_intro",
                            name: join_request.joinable_name)
    @url = mentor_team_url(join_request.joinable)

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.mentor_join_request_status.accepted_subject",
                              name: join_request.joinable_name),
      template_name: :join_request_status
  end

  def mentor_join_request_rejected(join_request)
    @intro = I18n.translate("team_mailer.mentor_join_request_status.rejected_intro",
                            name: join_request.joinable_name)

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.mentor_join_request_status.rejected_subject",
                              name: join_request.joinable_name),
      template_name: :join_request_status
  end

  def student_join_request_accepted(join_request)
    @intro = I18n.translate("team_mailer.student_join_request_status.accepted_intro",
                            name: join_request.joinable_name)
    @url = student_team_url(join_request.joinable)

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.student_join_request_status.accepted_subject",
                              name: join_request.joinable_name),
      template_name: :join_request_status
  end

  def student_join_request_rejected(join_request)
    @intro = I18n.translate("team_mailer.student_join_request_status.rejected_intro",
                            name: join_request.joinable_name)

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.student_join_request_status.rejected_subject",
                              name: join_request.joinable_name),
      template_name: :join_request_status
  end
end
