class AddRegardingToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :regarding, index: true, polymorphic: true
  end
end
