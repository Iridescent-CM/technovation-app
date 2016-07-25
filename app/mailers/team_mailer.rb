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
end
