# frozen_string_literal: true

class SecurityEvent < ActiveRecord::Base
  EVENT_TYPES = [
    "login.success",
    "login.failure",
    "login.lockout",
    "logout",
    "admin.impersonation.start",
    "admin.impersonation.stop",
    "admin.deactivated",
    "admin.reactivated",
    "password.changed",
    "password.reset"
  ].freeze

  belongs_to :account, optional: true
  belongs_to :actor_account, class_name: "Account", optional: true

  validates :event_type, presence: true, inclusion: {in: EVENT_TYPES}
end
