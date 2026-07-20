# frozen_string_literal: true

class SecurityEventLogger
  SENSITIVE_METADATA_KEYS = %w[
    password
    password_confirmation
    password_digest
    existing_password
    token
    auth_token
    session_token
  ].freeze

  def self.log(event_type:, account: nil, actor: nil, request: nil, metadata: {})
    new.log(
      event_type: event_type,
      account: account,
      actor: actor,
      request: request,
      metadata: metadata
    )
  end

  def log(event_type:, account: nil, actor: nil, request: nil, metadata: {})
    SecurityEvent.create!(
      event_type: event_type,
      account: account,
      actor_account: actor,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent,
      metadata: sanitize_metadata(metadata),
      created_at: Time.current
    )
  end

  private

  def sanitize_metadata(metadata)
    metadata.to_h.deep_stringify_keys.except(*SENSITIVE_METADATA_KEYS)
  end
end
