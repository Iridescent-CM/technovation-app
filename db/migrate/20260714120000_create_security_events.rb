# frozen_string_literal: true

class CreateSecurityEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :security_events do |t|
      t.string :event_type, null: false
      t.references :account, null: true, foreign_key: true, index: true
      t.references :actor_account, null: true, foreign_key: {to_table: :accounts}, index: true
      t.string :ip_address
      t.string :user_agent
      t.jsonb :metadata, null: false, default: {}
      t.datetime :created_at, null: false
    end

    add_index :security_events, :event_type
    add_index :security_events, :created_at
  end
end
