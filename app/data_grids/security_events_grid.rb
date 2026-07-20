# frozen_string_literal: true

class SecurityEventsGrid
  include ApplicationGrid

  scope do
    SecurityEvent.includes(:account, :actor_account).order(created_at: :desc)
  end

  column :created_at, header: "When", mandatory: true do |event|
    event.created_at.strftime("%Y-%m-%d %H:%M:%S %Z")
  end

  column :event_type, header: "Event", mandatory: true

  column :account, header: "Account", mandatory: true, html: true do |event|
    if event.account
      link_to event.account.email, admin_participant_path(event.account)
    else
      "—"
    end
  end

  column :actor, header: "Actor", mandatory: true, html: true do |event|
    if event.actor_account
      link_to event.actor_account.email, admin_participant_path(event.actor_account)
    else
      "—"
    end
  end

  column :ip_address, header: "IP", mandatory: true do |event|
    event.ip_address.presence || "—"
  end

  column :user_agent, header: "User agent", mandatory: true do |event|
    event.user_agent.to_s.truncate(80).presence || "—"
  end

  column :metadata, header: "Metadata", mandatory: true do |event|
    event.metadata.present? ? event.metadata.to_json : "—"
  end

  filter :event_type,
    :enum,
    select: SecurityEvent::EVENT_TYPES,
    filter_group: "common" do |value|
    where(event_type: value)
  end

  filter :created_at,
    :date,
    range: true,
    header: "Date",
    filter_group: "common"
end
