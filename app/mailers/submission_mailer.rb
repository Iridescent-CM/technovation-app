class SubmissionMailer < ActionMailer::Base

  default from: 'info@technovationchallenge.org'
  def submission_received_email(user, team)
    @user = user
    @team = team
    mail(to: user.email, subject: "Technovation submission received from #{@team.name}")
  end

end
