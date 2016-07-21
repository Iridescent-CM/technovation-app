class AmbassadorMailer < ApplicationMailer
  def approved(ambassador)
    mail to: ambassador.email
  end
end
