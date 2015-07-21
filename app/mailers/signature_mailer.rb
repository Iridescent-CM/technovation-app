class SignatureMailer < ActionMailer::Base
  default from: 'info@technovationchallenge.org'
  def signature_email(user)
    unless user.parent_email.nil?
      @link = SignatureController.link(user)
      mail(
        to: user.parent_email,
        subject: 'Technovation Letter to Parents - your daughter needs your permission to participate'
      )
      user.consent_sent_at = DateTime.now
      user.save!
    end
  end

  def confirmation_email(user)
    @link = SignatureController.link(user)
    mail(to: user.email, subject: 'Technovation Consent Form Signed')
  end
end
