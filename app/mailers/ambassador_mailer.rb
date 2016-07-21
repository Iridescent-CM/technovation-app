class AmbassadorMailer < ApplicationMailer
  default from: "info@technovationchallenge.org"

  def approved(ambassador)
    mail to: ambassador.email
  end
end
