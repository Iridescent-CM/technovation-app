class AdminMailer < ApplicationMailer
  def pending_regional_ambassador(ambassador)
    @name = ambassador.full_name
    @url = admin_participants_url(ambassador)

    I18n.with_locale(ambassador.locale) do
      mail to: "mailer@technovationchallenge.org",
          subject: "RA Application — Pending Approval"
    end
  end
end
