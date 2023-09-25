class RequestCheckrBackgroundCheckInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(candidate:)
    CheckrApiClient::ApiClient.new.request_checkr_invitation(candidate: candidate)
  end
end
