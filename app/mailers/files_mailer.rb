class FilesMailer < ApplicationMailer
  def export_ready(account, filename)
    filename = filename.sub("./public/", "")
    @url = "https://#{ENV.fetch("HOST_DOMAIN")}/#{filename}"
    mail to: account.email
  end
end
