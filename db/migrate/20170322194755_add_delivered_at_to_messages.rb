class AddDeliveredAtToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :delivered_at, :datetime
  end
end
