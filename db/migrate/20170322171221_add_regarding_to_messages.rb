class AddRegardingToMessages < ActiveRecord::Migration[4.2]
  def change
    add_reference :messages, :regarding, index: true, polymorphic: true
  end
end
