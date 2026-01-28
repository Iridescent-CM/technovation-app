class AddTwilioFieldsToTextMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :text_messages, :status, :integer
    add_column :text_messages, :error_code, :string
    add_column :text_messages, :error_message, :text

    add_index :text_messages, :status
  end
end
