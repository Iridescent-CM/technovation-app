class AddIsVirtualToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_virtual, :boolean
  end
end
