class TeamMailer < ApplicationMailer
  def invite_member(invite)
    @greeting = I18n.translate("team_mailer.invite_member.greeting.student", name: invite.team_name)

    if invite.invitee && invite.invitee.can_join_a_team?
      @url = student_team_member_invite_url(invite)
      @intro = I18n.translate("team_mailer.invite_member.intro.complete_profile")
      @link_text = "Review your invitation to this team"
    elsif invite.invitee
      @url = student_dashboard_url
      @intro = I18n.translate("team_mailer.invite_member.intro.incomplete_profile")
      @link_text = "Complete your profile to join this team"
    else
      attempt = SignupAttempt.create!(
        email: invite.invitee_email,
        password: SecureRandom.hex(17),
        status: SignupAttempt.statuses[:temporary_password],
      )

      @url = student_signup_url(token: attempt.activation_token)
      @intro = I18n.translate("team_mailer.invite_member.intro.no_profile")
      @link_text = "Signup to join this team"
    end

    mail to: invite.invitee_email, template_name: :invite_member
  end

  def invite_mentor(invite)
    @greeting = I18n.translate("team_mailer.invite_member.greeting.mentor", name: invite.team_name)

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
    @first_name = join_request.requestor_first_name
    @role_name = join_request.requestor_type_name
    @team_name = join_request.joinable_name
    @extra = I18n.translate("team_mailer.join_request.extra.#{join_request.requestor_type_name}", name: @first_name)
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
    @first_name = join_request.requestor_first_name
    @team_name = join_request.joinable_name
    @role_name = I18n.translate("team_mailer.#{type}_join_request_status.role_name")

    if status == :accepted
      @url = send("#{type}_team_url", join_request.joinable)
    end

    if status == :declined
      @extra = I18n.translate("team_mailer.#{type}_join_request_status.declined_extra")
      @url = send("new_#{type}_team_search_url")

      if type == :student
        @extra_url = "http://www.technovationchallenge.org/wp-content/uploads/2014/11/RecruitmentTipsAmbassador.pdf"
      end
    end

    mail to: join_request.requestor_email,
      subject: I18n.translate("team_mailer.#{type}_join_request_status.#{status}_subject",
                              name: join_request.joinable_name),
      template_name: "join_request_#{status}"
  end
end
