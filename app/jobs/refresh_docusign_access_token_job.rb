class RefreshDocusignAccessTokenJob < ActiveJob::Base
  queue_as :default

  def perform
    Docusign::Authentication.new.refresh_access_token
  end
end
