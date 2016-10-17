class AdminMailer < ApplicationMailer
  def pending_regional_ambassador(ambassador)
    @name = ambassador.full_name
    @url = admin_regional_ambassadors_url(status: :pending)

    I18n.with_locale(ambassador.locale) do
      mail to: "info@technovationchallenge.org",
          subject: "RA Application — Pending Approval"
    end
  end
end
