class CreateJoinRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :join_requests do |t|
      t.references :requestor, index: true, polymorphic: true, null: false
      t.references :joinable, index: true, polymorphic: true, null: false
      t.datetime :accepted_at, index: true
      t.datetime :rejected_at, index: true

      t.timestamps null: false

      t.foreign_key "accounts", column: :requestor_id
      t.foreign_key "teams", column: :joinable_id
    end
  end
end
