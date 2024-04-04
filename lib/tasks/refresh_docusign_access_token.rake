desc "Refresh DocuSign access token"
task refresh_docusign_access_token: :environment do
  RefreshDocusignAccessTokenJob.perform_now
end
