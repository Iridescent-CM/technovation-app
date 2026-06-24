require "fill_pdfs"

class CertificateDownloadsController < ApplicationController
  before_action :require_signed_in_account
  before_action :set_certificate

  def show
    return head :forbidden unless authorized?

    if @certificate.file.present?
      redirect_to @certificate.file_url, allow_other_host: true
      return
    end

    pdf_data = FillPdfs.render_pdf(CertificateRecipient.from_certificate(@certificate))

    send_data(
      pdf_data,
      filename: download_filename,
      type: "application/pdf",
      disposition: "inline"
    )
  end

  private

  def authorized?
    @certificate.account_id == current_account.id || current_account.admin?
  end

  def require_signed_in_account
    return if current_account.authenticated?

    redirect_to signin_path,
      notice: t("controllers.application.generic_unauthenticated")
  end

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end

  def download_filename
    "#{@certificate.season}-#{@certificate.cert_type}-certificate.pdf"
  end
end
