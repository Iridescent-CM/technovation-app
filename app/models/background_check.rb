class BackgroundCheck < ActiveRecord::Base
  enum status: %i{ pending clear consider suspended }

  belongs_to :account

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
