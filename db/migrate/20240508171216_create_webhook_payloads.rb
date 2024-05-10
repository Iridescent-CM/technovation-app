class CreateWebhookPayloads < ActiveRecord::Migration[6.1]
  def change
    create_table :webhook_payloads do |t|
      t.text :body

      t.timestamps
    end
  end
end
