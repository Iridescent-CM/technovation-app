class RemoveMessages < ActiveRecord::Migration[6.1]
  def up
    drop_table :messages
    drop_table :multi_messages
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reversed because it destroys the messages and multi_messages tables."
  end
end
