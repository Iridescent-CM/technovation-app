class AmbassadorMailer < ApplicationMailer
  def approved(ambassador)
    mail to: ambassador.email
  end

  def declined(ambassador)
    @first_name = ambassador.first_name
    @status = ambassador.status
    mail to: ambassador.email
  end
end
