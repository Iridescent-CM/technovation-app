class DropEvents < ActiveRecord::Migration[5.1]
  def up
    if table_exists?(:events)
      drop_table :events
    end
  end
end
