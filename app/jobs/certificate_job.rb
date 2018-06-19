class CertificateJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, team_id = nil)
  end
end