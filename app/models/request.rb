class Request < ApplicationRecord
  enum request_type: %w{
    AMBASSADOR_ADD_REGION
  }

  enum request_status: %w{
    pending
    approved
    declined
    archived
  }

  belongs_to :requestor, polymorphic: true
  belongs_to :target, polymorphic: true

  delegate :avatar, :name,
    to: :requestor,
    prefix: true

  validates :request_type, presence: true

  before_create -> {
    self.status_updated_at = updated_at
  }

  after_commit -> {
    if saved_change_to_request_status?
      update_column(:status_updated_at, Time.current)
    end
  }
end
