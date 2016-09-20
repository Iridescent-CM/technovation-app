class FilesMailer < ApplicationMailer
  def export_ready(account, export)
    @first_name = account.first_name
    @url = export.file_url
    mail to: account.email
  end
end
