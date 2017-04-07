class CreateMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.string :recipient_type
      t.integer :sender_id
      t.string :sender_type
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
