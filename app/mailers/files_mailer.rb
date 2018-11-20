class FilesMailer < ApplicationMailer
  def export_ready(account, export, email = nil)
    @first_name = account.first_name
    @url = export.file_url

    I18n.with_locale(account.locale) do
      mail to: email || account.email
    end
  end

  def report_affected_users(account, export)
    @first_name = account.first_name
    @url = export.file_url

    I18n.with_locale(account.locale) do
      mail to: account.email,
        subject: "Password Reset CSV Export of Affected Users"
    end
  end
end
