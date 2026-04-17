class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.integer :requestor_id, foreign_key: true, null: false
      t.string :requestor_type, null: false
      t.integer :target_id, foreign_key: true, null: false
      t.string :target_type, null: false
      t.integer :request_type, null: false
      t.integer :request_status, null: false, default: 0
      t.json :requestor_meta
      t.text :requestor_message

      t.datetime :status_updated_at, null: false

      t.timestamps
    end
  end
end
