class SignatureMailer < ActionMailer::Base
  default from: 'info@technovationchallenge.org'
  def signature_email(user)
    @link = SignatureController.link(user)
    mail(to: user.parent_email, subject: 'Technovation Letter to Parents')
    user.consent_sent_at = DateTime.now
    user.save!
  end
end
