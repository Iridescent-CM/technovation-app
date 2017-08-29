class BackgroundCheck < ActiveRecord::Base
  enum status: %i{ pending clear consider suspended }

  belongs_to :account

  after_save -> {
    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end
  }, if: -> { saved_change_to_status? and clear? }

  after_destroy -> {
    account.mentor_profile.disable_searchability
  }, if: -> { account.mentor_profile.present? }

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
