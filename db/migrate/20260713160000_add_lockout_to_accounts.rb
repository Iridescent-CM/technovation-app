# frozen_string_literal: true

class AddLockoutToAccounts < ActiveRecord::Migration[7.2]
  def change
    change_table :accounts, bulk: true do |t|
      t.integer :failed_attempts, null: false, default: 0
      t.datetime :locked_at
    end
  end
end
