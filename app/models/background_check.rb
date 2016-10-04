class BackgroundCheck < ActiveRecord::Base
  enum status: %i{ pending clear consider suspended engage }

  belongs_to :account

  after_save -> { account.after_background_check_clear },
    if: -> { status_changed? and clear? }

  after_destroy -> { account.after_background_check_deleted }

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
