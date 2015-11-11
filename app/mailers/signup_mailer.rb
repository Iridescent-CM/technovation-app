class SignupMailer < ActionMailer::Base
  default from: 'info@technovationchallenge.org'

  def judge_signup_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to Technovation!')
  end

  def mentor_signup_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to the Technovation Mentor Community!')
  end
end
