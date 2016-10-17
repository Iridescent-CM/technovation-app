class FilesMailer < ApplicationMailer
  def export_ready(account, export)
    @first_name = account.first_name
    @url = export.file_url

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end
end
