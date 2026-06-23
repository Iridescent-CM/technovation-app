require "rails_helper"

RSpec.describe CertificateDownloadsController do
  let(:account) { FactoryBot.create(:student).account }
  let(:team) { FactoryBot.create(:team) }
  let!(:certificate) do
    FactoryBot.create(
      :certificate,
      account: account,
      team: team,
      season: Season.current.year - 1,
      cert_type: :participation
    )
  end

  describe "GET #show" do
    it "generates and returns a PDF for the account's previous certificate" do
      sign_in account.student_profile

      get certificate_download_path(certificate)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/pdf")
      expect(response.body).to start_with("%PDF")
    end

    it "forbids access to another account's certificate" do
      other_account = FactoryBot.create(:student).account
      sign_in other_account.student_profile

      get certificate_download_path(certificate)

      expect(response).to have_http_status(:forbidden)
    end

    it "redirects unauthenticated users to sign in" do
      get certificate_download_path(certificate)

      expect(response).to redirect_to(signin_path)
    end
  end
end
