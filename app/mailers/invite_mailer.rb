class InviteMailer < ActionMailer::Base
  default from: 'info@technovationchallenge.org'
  def invite_received_email(user, team)
    @user = user
    @team = team
    mail(to: user.email, subject: "Technovation team invite received from #{@team.name}")
  end

  def invite_accepted_email(user, team)
    @user = user
    @team = team
    mail(to: user.email, subject: "Technovation team invite to #{@team.name} accepted")
  end
end
