class AdminMailer < ApplicationMailer
  def pending_regional_ambassador(ambassador)
    @name = ambassador.full_name
    @url = admin_pending_regional_ambassadors_url
    mail to: "info@technovationchallenge.org",
         subject: "RA Application — Pending Approval"
  end
end
