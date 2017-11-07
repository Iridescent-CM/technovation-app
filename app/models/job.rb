class Job < ActiveRecord::Base
  scope :queued, -> { where(status: "queued") }
  scope :complete, -> { where(status: "complete") }
  scope :owned_by, ->(user) { where(owner: user) }

  belongs_to :owner, polymorphic: true
end
