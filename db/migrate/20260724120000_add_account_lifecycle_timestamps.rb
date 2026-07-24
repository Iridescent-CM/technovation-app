# frozen_string_literal: true

class AddAccountLifecycleTimestamps < ActiveRecord::Migration[7.2]
  def up
    change_table :accounts, bulk: true do |t|
      t.datetime :password_changed_at
      t.datetime :deactivated_at
    end

    execute <<~SQL.squish
      UPDATE accounts
      SET password_changed_at = CURRENT_TIMESTAMP
      WHERE password_changed_at IS NULL
    SQL
  end

  def down
    change_table :accounts, bulk: true do |t|
      t.remove :password_changed_at
      t.remove :deactivated_at
    end
  end
end
