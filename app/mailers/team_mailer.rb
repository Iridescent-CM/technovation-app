class TeamMailer < ApplicationMailer
  def invite_member(team_member_invite)
    invite(:team_member, nil, team_member_invite)
  end

  def invite_mentor(mentor_invite)
    invite(:mentor, :mentor_, mentor_invite)
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
    join_request_status(:accepted, :mentor, join_request)
  end

  def mentor_join_request_rejected(join_request)
    join_request_status(:rejected, :mentor, join_request)
  end

  def student_join_request_accepted(join_request)
    join_request_status(:accepted, :student, join_request)
  end

  def student_join_request_rejected(join_request)
    join_request_status(:rejected, :student, join_request)
  end

  private
  def invite(type, prefix, invite)
    @url = send("#{prefix}#{type}_invite_url", invite)
    mail to: invite.invitee_email,
         template_name: :invite_member
  end

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
