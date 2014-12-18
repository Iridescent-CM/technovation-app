class InviteMailer < ActionMailer::Base
  default from: 'info@technovationchallenge.org'
  def invite_received_email(user, team)
    @user = user
    @team = team
    mail(to: user.email, subject: "Technovation team invite received from #{@team.name}")
  end
end
