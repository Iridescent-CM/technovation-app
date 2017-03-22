class AddSentAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sent_at, :datetime
  end
end
