class AdminMailer < ApplicationMailer
  default from: "info@technovationchallenge.org"

  def pending_regional_ambassador(ambassador)
    @name = ambassador.full_name
    @url = admin_pending_regional_ambassadors_url
    mail to: "info@technovationchallenge.org"
  end
end
