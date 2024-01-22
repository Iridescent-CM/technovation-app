class BackgroundCheck < ActiveRecord::Base
  # If these change, you will need to update dataclips
  enum status: %i[pending clear consider suspended canceled invitation_required]
  enum invitation_status: %i[pending completed expired], _prefix: :invitation
  enum internal_invitation_status: %i[requesting_invitation invitation_sent error]

  belongs_to :account

  after_destroy -> {
    account.mentor_profile.disable_searchability
  }, if: -> {
    MentorProfile.exists?(account.mentor_profile && account.mentor_profile.id)
  }

  def submitted?
    pending?
  end

  class << self
    def get(resource, id)
      Checkr.request(:get, "/v1/#{resource}/#{id}")
    end

    def post(resource, attributes)
      Checkr.request(:post, "/v1/#{resource}", attributes)
    end
  end
end
