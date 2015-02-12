module GoogleSession
  class << self

    def create
      client = Google::APIClient.new({application_name: 'Google Drive Ruby test', application_version: '0.0.1'})
      key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.application.config.env['gdrive']['p12_path'], Rails.application.config.env['gdrive']['secret'])

      asserter = Google::APIClient::JWTAsserter.new(
          Rails.application.config.env['gdrive']['email_address'],
          ['https://www.googleapis.com/auth/drive'],
          key
      )
      client.authorization = asserter.authorize
      GoogleDrive.login_with_oauth(client.authorization.access_token)
    end
  end
end