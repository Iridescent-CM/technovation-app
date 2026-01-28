class CreateTextMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :text_messages do |t|
      t.references :account, null: false, index: true, foreign_key: true
      t.integer :season, null: false, limit: 2
      t.integer :delivery_method, null: false
      t.integer :message_type, null: false
      t.string :external_message_id
      t.string :recipient, null: false
      t.datetime :sent_at, null: false

      t.timestamps
    end

    add_index :text_messages, :message_type
  end
end
