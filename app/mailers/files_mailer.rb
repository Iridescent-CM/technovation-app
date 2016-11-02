class FilesMailer < ApplicationMailer
  def export_ready(account, export, email = nil)
    @first_name = account.first_name
    @url = export.file_url

    I18n.with_locale(account.locale) do
      mail to: email || account.email
    end
  end
end
