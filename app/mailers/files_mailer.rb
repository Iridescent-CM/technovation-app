class FilesMailer < ApplicationMailer
  def export_ready(account, export)
    @url = export.file_url
    mail to: account.email
  end
end
