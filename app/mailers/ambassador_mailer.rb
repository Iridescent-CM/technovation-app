class AmbassadorMailer < ApplicationMailer
  def approved(ambassador)
    mail to: ambassador.email
  end

  def declined(ambassador)
    mail to: ambassador.email
  end
end
